import { assert } from 'chai';
import { describe, it } from 'mocha';

import FeedbackStore from '../stores/FeedbackStore';

describe('FeedbackStore', () => {
  it('initializes empty name field', () => {
    const feedbackStore = new FeedbackStore();

    assert.empty(feedbackStore.name);
  });

  it('initializes empty comment field', () => {
    const feedbackStore = new FeedbackStore();

    assert.empty(feedbackStore.comment);
  });

  it('allows writes and reads to name field', () => {
    const feedbackStore = new FeedbackStore();

    feedbackStore.setName('Cloud');

    assert.equal(feedbackStore.name, 'Cloud');
  });

  it('allows writes and reads to comment field', () => {
    const feedbackStore = new FeedbackStore();

    feedbackStore.setComment('Go White Sox');

    assert.equal(feedbackStore.comment, 'Go White Sox');
  });
});
