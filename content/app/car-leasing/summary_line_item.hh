<div class="col s6">
  <span class="col s6">
    [[ $ctrl.label ]]
  </span>
  <div class="col s6">
    <span ng-show="$ctrl.type=='$'">$</span>
    <span ng-class="{'myhighlight': $ctrl.model < 0}">
      [[ $ctrl.model | number: $ctrl.decimal_place ]]
    </span>
    <span ng-show="$ctrl.type=='%'">%</span>
    <span ng-show="$ctrl.type=='month'">months</span>
  </div>
</div>
