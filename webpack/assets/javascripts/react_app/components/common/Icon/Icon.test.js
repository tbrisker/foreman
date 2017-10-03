// Configure Enzyme
import { configure } from 'enzyme';
import Adapter from 'enzyme-adapter-react-15';
configure({ adapter: new Adapter() });

jest.unmock('./');

import React from 'react';
import { shallow } from 'enzyme';
import Icon from './';

describe('Icon', () => {
  it('displays icon css', () => {
    const wrapper = shallow(<Icon type="ok" />);

    expect(wrapper.html()).toEqual('<span class="pficon pficon-ok"></span>');
  });
  it('can receive additionl css classes', () => {
    const wrapper = shallow(<Icon type="ok" className="pull-left" />);

    expect(wrapper.html()).toEqual('<span class="pficon pficon-ok pull-left"></span>');
  });
});
