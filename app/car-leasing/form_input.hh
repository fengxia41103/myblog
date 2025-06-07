<div class="input-field col s11">
  <label class="active">
    [[ $ctrl.label ]]
    <span  ng-show="$ctrl.type=='$'">$</span>
    <span ng-show="$ctrl.type=='%'">%</span>
    <span ng-show="$ctrl.type=='month'">month</span>
  </label>
  <input type="number"
         min="[[$ctrl.min]]"
         max="[[$ctrl.max]]"
         step="[[$ctrl.step]]"
         ng-model="$ctrl.model">
</div>
