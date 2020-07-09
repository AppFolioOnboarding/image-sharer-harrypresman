import { observer } from 'mobx-react';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

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
          <input id='fname' onChange={(event) => { feedbackStore.name = event.target.value; }} />
        </label>
        <br />
        <label htmlFor="fcomment">Comments:
          <textarea
            id='fcomment'
            onChange={(event) => { feedbackStore.comment = event.target.value; }}
          />
        </label>
        <br />
        <input type='submit' />
      </form>
    );
  }
}
