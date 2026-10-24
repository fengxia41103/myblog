<div>
  <h6 class="myhighlight nocount">
    Assumptions
  </h6>

  <table class="table striped bordered highlight">
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
          <span ng-show="m.type=='$'">$</span>
          [[ m.value | number:"2" ]]
          <span ng-show="m.type=='%'">%</span>
        </td>
      </tr>
    </tbody>
  </table>
</div>
