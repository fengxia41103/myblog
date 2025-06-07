<div class="col s11">
  <label class="active">
    [[ $ctrl.label ]]
    <span ng-show="$ctrl.type=='$'">$</span>
    <span ng-show="$ctrl.type=='%'">%</span>
  </label>
  <input disabled type="number"
         ng-class="{'myhighlight': $ctrl.model < 0}"
         value="[[ $ctrl.model | number: $ctrl.decimal_place ]]"
  />

</div>
