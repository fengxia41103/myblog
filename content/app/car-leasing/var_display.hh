<div class="row form-group">
    <span class="col-xs-6 col-form-label text-right">[[ $ctrl.label ]]</span>
    <div class="col-xs-6" style="border-bottom:1px solid #efefef;">
        <span ng-show="$ctrl.type=='$'">$</span>
        <span ng-class="{'myhighlight': $ctrl.model < 0}">
        [[ $ctrl.model | number: $ctrl.decimal_place ]]
        </span>
        <span ng-show="$ctrl.type=='%'">%</span>
    </div>
</div>
