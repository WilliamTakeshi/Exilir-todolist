import React from "react";

export default class BasicModal extends React.Component {
  constructor(props) {
    super(props);
  }


  render() {
    const display = (this.props.show ? 'grid' : 'none')
    return (
      <div id="modal1" className="modal" style={{display: display}}>
        <div className="modal-content">
          <h4>{this.props.title}</h4>
          <p>{this.props.body}</p>
        </div>
        <div className="modal-footer">
          {(this.props.okClick ? <a onClick={this.props.okClick} className="modal-close waves-effect waves-green btn-flat">Ok</a> : '')}
          {(this.props.cancelClick ? <a onClick={this.props.cancelClick} className="modal-close waves-effect waves-green btn-flat">Cancel</a> : '')}
        </div>
      </div>
    )
  }
}
