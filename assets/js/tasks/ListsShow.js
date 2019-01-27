import axios from 'axios';
import React from "react";
import ReactDOM from "react-dom";
import update from 'immutability-helper';
import {RIEInput} from 'riek'
import BasicModal from '../components/BasicModal.js'
export default class ListsShow extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      list: {
        id: '',
        inserted_at: '',
        name: '',
        public: '',
        updated_at: '',
        tasks: [],
      },
      error: '',
      showDeleteModal: false
    }

    this._addNewTaskToState = this._addNewTaskToState.bind(this);
    this._handleKeyPress = this._handleKeyPress.bind(this);
    this._isOwner = this._isOwner.bind(this);
  }

  _addNewTaskToState(task) {
    const newData = update(this.state.list, {
      tasks: {$push: [task]}
    });

    this.setState({"list": newData})
  }

  componentDidMount() {
    axios.all([
      axios.get('/api/lists/' +  this._getListId()),
      axios.get('/api/whoami'),
    ]).then(axios.spread((listData, userData) => {
        this.setState({
          list: listData.data.data,
          user: userData.data.data
        })
      })).catch(_error => {
        this.setState({"error": "Error loading your list, please try again"});
      });
  }

  _createNewTask(name, listId) {
    axios.post('/api/lists/' + listId + '/tasks', {task: {name: name, done: false}})
      .then(response => {
        this._addNewTaskToState(response.data.data)
      }).catch(_error => {
        this.setState({"error": "Error creating task, please try again"});
      });
  }

  _deleteTask(task) {
    axios.delete('/api/lists/' + task.list_id + '/tasks/' + task.id)
      .then(() => this._deleteTaskState(task))
      .catch(_error => {
        this.setState({"error": "Error deleting task, please try again"});
      });
  }

  _deleteList() {
    axios.delete('/api/lists/' + this._getListId())
      .then(() => {
        window.location.href = "/";
      })
      .catch(_error => {
        this.setState({
          "error": "Error deleting list, please try again",
          showDeleteModal: false
        });
      });
  }

  _deleteTaskState(task) {

    const newData = update(this.state.list, 
      {tasks: {$set: taskList.filter(t => t.id != task.id)}}
    );
    this.setState({"list": newData})
  }

  _editTask(field, value, task) {
    axios.put('/api/lists/' + task.list_id + '/tasks/' + task.id, {task: {[field]: value}})
      .then(response => {
        this._updateNewTaskToState(response.data.data)
      }).catch(_error => {
        this.setState({"error": "Error editing task, please try again"});
      });
  }

  _getListId() {
    const re = /lists\/(\d+)/;
    var result = re.exec(document.URL);
    return result[1];
  }

  _handleKeyPress(e) {
    if (e.key == 'Enter') {
      this.setState({newTaskName: ''});
      this._createNewTask(this.state.newTaskName, this._getListId())
    }
  }

  _handleRIEInputChange(value, task) {
    this._editTask("name", value.name, task)
  }

  _isOwner() {
    if (this.state.list && this.state.user){
      return this.state.list.user_id === this.state.user.id;
    }
    return false;
  }

  _renderError() {
    let error = this.state.error;
    if (!error) return false;

    return (
      <div className="error">
        {error}
      </div>
    );
  }

  _renderTask(task) {
    return (
      <div className="row" key={task.id}>
        <label className="col s3 m3" style={{marginTop: '16px'}}>
          <input type="checkbox" checked={task.done} onChange={e => this._editTask("done", e.target.checked, task)}/>
          <span></span>
        </label>
        <RIEInput
          classEditing="input-field col s5 m5"
          className={"input-field col s5 m5" + (task.done ? ' finished-task' : '')}
          value={task.name}
          change={name => this._handleRIEInputChange(name, task)}
          propName='name' />
        <i className="small material-icons" onClick={() => this._deleteTask(task)}>delete</i>
      </div>
    )
  }

  _renderSomeoneTask(task) {
    return (
      <div className="row" key={task.id}>
        <p className="input-field col s11 m11">{task.name}</p>
      </div>
    )
  }

  render() {
    const isOwner = this._isOwner();
    return (
      <div>
        {(isOwner ? 
        <BasicModal
          show={this.state.showDeleteModal}
          title="Caution!"
          body="Are you sure you want to delete this list? It can not be recovered later."
          okClick={() => this._deleteList()}
          cancelClick={() => this.setState({showDeleteModal: false})}
        /> :
        '')}


        <h3>{this.state.list.name}</h3>
        <p>Created at, last updated at</p>
        {this._renderError()} 
        <br/><br/>  
        <center>
          {(isOwner ? 
          <span>
          <p>Break down time! Type the task name and hit enter</p>
          <div className="row">
            <div className="input-field col s12">
              <input
                type="text"
                value={this.state.newTaskName}
                onChange={e => this.setState({newTaskName: e.target.value})}
                onKeyPress={this._handleKeyPress}></input>
            </div>
          </div>
          {this.state.list.tasks.map(task => this._renderTask(task))}
          </span> :
          <span>{this.state.list.tasks.map(task => this._renderSomeoneTask(task))}</span>)}

        {(isOwner ? 
          <button className="btn red" onClick={() => this.setState({showDeleteModal: true})}>Delete</button> :
          '')}
        </center>
      </div>
    )
  }

  _updateNewTaskToState(task) {
    const taskList = this.state.list.tasks
    let idx;

    for (let i=0; i < taskList.length; i++) {
      if (taskList[i].id === task.id) {
        idx=i;
        break;
      }
    }
    const newData = update(this.state.list, 
        {tasks: {[idx]: {$set: task}}}
    );
    this.setState({"list": newData})
  }

  _updateList(field, value) {
    const newData = update(this.state.list, {
      [field]: {$set: value}
    });

    this.setState({"list": newData})
  }

}

ReactDOM.render(
  <ListsShow />,
  document.getElementById('react_lists_show'),
);