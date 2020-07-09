import { observable } from 'mobx';

export default class FeedbackStore {
  @observable name = '';
  @observable comment = '';
}
