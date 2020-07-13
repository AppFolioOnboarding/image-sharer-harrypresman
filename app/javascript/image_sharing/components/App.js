import { inject } from 'mobx-react';
import PropTypes from 'prop-types';
import React, { Component } from 'react';

import Header from './Header';
import FeedbackForm from './FeedbackForm';
import Footer from './Footer';

class App extends Component {
  static propTypes = {
    stores: PropTypes.shape({
      feedbackStore: PropTypes.object.isRequired
    })
  };
  render() {
    return (
      <div>
        <Header title="Tell us what you think" />
        <FeedbackForm feedbackStore={this.props.stores.feedbackStore} />
        <Footer />
      </div>
    );
  }
}

export default inject('stores')(App);
