import React, { Component } from 'react';

export default class FeedbackForm extends Component {
  render() {
    return (
      <form>
        <label htmlFor="fname">Your name:<input id='fname'/></label>
        <br/>
        <label htmlFor="fcomments">Comments:<textarea id='fcomments'/></label>
        <br />
        <input type='submit'/>
      </form>
    );
  }
}
