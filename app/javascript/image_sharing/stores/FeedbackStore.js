import { action, observable } from 'mobx';

export default class FeedbackStore {
  @observable name = '';
  @observable comment = '';

  @action setName(name) {
    this.name = name;
  }

  @action setComment(comment) {
    this.comment = comment;
  }
}
