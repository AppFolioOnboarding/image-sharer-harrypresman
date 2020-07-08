/* eslint-env mocha */

import { assert } from 'chai';
import { shallow } from 'enzyme';
import React from 'react'
import Footer from '../components/footer'

describe('footer', () => {
  it('displays copyright text', () => {
    const wrapper = shallow(<Footer />);

    assert.equal(wrapper.find('h4').text(), 'Copyright: Appfolio Inc. Onboarding');
  });
});
