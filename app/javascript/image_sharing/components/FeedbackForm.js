import { observer } from 'mobx-react';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

function updateName(store, name) {
  store.setName(name);
}

function updateComment(store, comment) {
  store.setComment(comment);
}

@observer
export default class FeedbackForm extends Component {
  static propTypes = {
    feedbackStore: PropTypes.object.isRequired
  };
  render() {
    const feedbackStore = this.props.feedbackStore;
    return (
      <form>
        <label htmlFor="fname">Your name:
          <input id='fname' onChange={event => updateName(feedbackStore, event.target.value)} />
        </label>
        <br />
        <label htmlFor="fcomment">Comments:
          <textarea
            id='fcomment'
            onChange={event => updateComment(feedbackStore, event.target.value)}
          />
        </label>
        <br />
        <input type='submit' />
      </form>
    );
  }
}
