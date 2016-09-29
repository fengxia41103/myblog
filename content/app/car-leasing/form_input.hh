<div class="row form-group">
    <span class="col-xs-6 col-form-label text-right">[[ $ctrl.label ]]</span>
    <div class="col-xs-5 input-group" style="float:left;">
        <div class="input-group-addon" ng-show="$ctrl.type=='$'">$</div>
        <input type="number" class="form-control" min="0" ng-model="$ctrl.model">
        <div class="input-group-addon" ng-show="$ctrl.type=='%'">%</div>
        <div class="input-group-addon" ng-show="$ctrl.type=='month'">month</div>
    </div>
</div>
