import { assert } from 'chai';
import { shallow } from 'enzyme';
import { describe, it } from 'mocha';
import React from 'react';
import sinon from 'sinon';

import FeedbackForm from '../components/FeedbackForm';
import FeedbackStore from '../stores/FeedbackStore';

describe('FeedbackForm', () => {
  it('contains a name field', () => {
    const wrapper = shallow(<FeedbackForm feedbackStore={sinon.stub()} />);

    assert.equal(wrapper.find('label[htmlFor="fname"]').text(), 'Your name:');
  });

  it('contains a comments field', () => {
    const wrapper = shallow(<FeedbackForm feedbackStore={sinon.stub()} />);

    assert.equal(wrapper.find('label[htmlFor="fcomment"]').text(), 'Comments:');
  });

  it('contains a submit button', () => {
    const wrapper = shallow(<FeedbackForm feedbackStore={sinon.stub()} />);

    assert(wrapper.exists('input[type="submit"]'));
  });
});


describe('FeedbackForm integration', () => {
  it('writes name data to the store on change', () => {
    const feedbackStore = new FeedbackStore();
    const wrapper = shallow(<FeedbackForm feedbackStore={feedbackStore} />);
    const nameInput = wrapper.find('#fname');

    nameInput.simulate('change', { target: { value: 'Chronos' } });

    assert.equal('Chronos', feedbackStore.name);
  });

  it('writes comment data to the store on change', () => {
    const feedbackStore = new FeedbackStore();
    const wrapper = shallow(<FeedbackForm feedbackStore={feedbackStore} />);
    const commentInput = wrapper.find('#fcomment');

    commentInput.simulate('change', { target: { value: 'Like a boss' } });

    assert.equal('Like a boss', feedbackStore.comment);
  });
});
