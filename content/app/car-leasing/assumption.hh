<div type="button" class="dropdown btn btn-link myhighlight" style="margin-bottom: 1em;">
    <span class="dropdown-toggle" id="$ctrl.id" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
        <i class="fa fa-flag"></i>
        Assumptions
        <span class="caret"></span>
    </span>
    <ul class="dropdown-menu" aria-labelledby="$ctrl.id" style="padding:10px 20px;">
        <table class="table table-striped table-hover table-responsive">
            <thead>
                <th>Item</th>
                <th>Value</th>
            </thead>
            <tbody>
                <tr ng-repeat="m in $ctrl.values">
                    <td>
                        [[ m.name ]]
                    </td>
                    <td>
                        <span ng-show="m.type=='$'">$</span> [[ m.value | number:"2" ]]
                        <span ng-show="m.type=='%'">%</span>
                    </td>
                </tr>
            </tbody>
        </table>
    </ul>
</div>
