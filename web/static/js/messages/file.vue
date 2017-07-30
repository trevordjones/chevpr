<template lang="html">
  <div>
    <div class="modal fade" id="snippet" tabindex="-1" role="dialog">
      <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">Modal title</h4>
            <select class="form-control">
              <option v-for="language in languages">{{language}}</option>
            </select>
          </div>
          <div class="modal-body">
            <textarea rows="10" class="form-control"></textarea>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary">Save changes</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {languages} from './languages'

export default {
  data() {
    return {
      languages: languages
    }
  }
}
</script>

<style lang="css">
</style>
