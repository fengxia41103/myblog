<span class="btn flabel">
    <span>[[ $ctrl.label ]]:</span>
    <span ng-show="$ctrl.type=='$'">$</span>
    <span ng-class="{'myhighlight': $ctrl.model < 0}">
        [[ $ctrl.model | number: $ctrl.decimal_place ]]
    </span>
    <span ng-show="$ctrl.type=='%'">%</span>
</span>
