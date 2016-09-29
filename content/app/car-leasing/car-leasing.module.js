// Define the 'carLeasing' module
angular.
module('carLeasing', []).
controller('CarLeasingController', ['$scope',
    function($scope) {
        var vm = $scope;
        var finance = new Finance();

        // constants
        var security_refund_rate = 0.2;
        vm.example_msrp = 18881;
        vm.example_lease = 13270;
        vm.msrp = 25375;
        vm.invoice = 24440;
        vm.purchase = 23000;
        vm.lease = 21287;
        vm.sales_tax = 6;
        vm.msd_mf_discount = 0.00007;
        vm.max_msd_allowed = 7;
        vm.msd_selected = 7;
        vm.apr = 4;
        vm.term = 36;
        vm.downpayment = 2000;
        vm.rebates = 0;
        vm.credits = 0;
        vm.monthly_tax = 3;
        vm.registration_fee = 40;
        vm.plate_fee = 28;
        vm.documentation_fee = 550;
        vm.acquisition_fee = 995;
        vm.security_deposit = 0;
        vm.monthly_lease_payment_before_tax = 0;
        vm.monthly_lease_payment_after_tax = 0;
        vm.msd = 0;
        vm.disposition_fee = 350;
        vm.wear_charge = 0;

        // Prices and discounts
        vm.$watchGroup(['msrp', 'invoice', 'purchase', 'lease'],
            function(newVal, oldVal) {
                // Discounts from MSRP
                vm.msrp_invoice_discount = (vm.msrp - vm.invoice) / vm.msrp * 100;
                vm.msrp_purchase_discount = (vm.msrp - vm.purchase) / vm.msrp * 100;
                vm.msrp_lease_discount = (vm.msrp - vm.lease) / vm.msrp * 100;

                // Discount from invoice
                vm.invoice_purchase_discount = (vm.invoice - vm.purchase) / vm.invoice * 100;
                vm.invoice_lease_discount = (vm.invoice - vm.lease) / vm.invoice * 100;
            });

        // Official lease example
        vm.$watchGroup(['example_msrp', 'example_lease'],
            function(newVal, oldVal) {
                vm.residue = vm.example_lease / vm.example_msrp * 100;
                vm.residue = parseFloat(vm.residue.toFixed(2));
            });

        // Residue value
        vm.$watchGroup(['msrp', 'residue'],
            function(newVal, oldVal) {
                vm.residue_value = vm.msrp * vm.residue / 100;
            });

        // MF
        vm.$watchGroup(['apr', 'msd_selected', 'msd_mf_discount'],
            function() {
                vm.dealer_mf = vm.apr / 2400;
                vm.max_msd_discount = vm.msd_selected * vm.msd_mf_discount;
                vm.actual_mf = vm.dealer_mf - vm.max_msd_discount;
                vm.actual_apr = vm.actual_mf * 2400;
                vm.msd_discount_apr = -1 * vm.max_msd_discount * 2400;
            });

        // Deal
        vm.$watchGroup(['lease', 'sales_tax', 'downpayment', 'rebates', 'credits'],
            function() {
                vm.lease_after_tax = vm.lease * (1 + vm.sales_tax / 100);
                vm.net_capital_cost = vm.lease_after_tax - vm.downpayment - vm.rebates - vm.credits;
            });

        // Depreciation cost
        vm.$watchGroup(['net_capital_cost', 'residue_value', 'term'],
            function() {
                vm.depreciation_cost = vm.net_capital_cost - vm.residue_value;
                vm.monthly_depreciation = vm.depreciation_cost / vm.term;
            });

        // Financing cost
        vm.$watchGroup(['net_capital_cost', 'residue_value', 'actual_mf'],
            function() {
                vm.financing_cost = vm.net_capital_cost + vm.residue_value;
                vm.monthly_financing = vm.financing_cost * vm.actual_mf;
            });

        // Monthly lease payment
        vm.$watchGroup(['monthly_depreciation', 'monthly_financing', 'monthly_tax', 'msd_selected'],
            function() {
                vm.monthly_lease_payment_before_tax = vm.monthly_depreciation + vm.monthly_financing;
                vm.monthly_lease_payment_after_tax = vm.monthly_lease_payment_before_tax * (1 + vm.monthly_tax / 100);
                vm.monthly_tax_charge = vm.monthly_lease_payment_after_tax - vm.monthly_lease_payment_before_tax;

                // MSD is rounded to the nearest 50
                vm.msd = Math.ceil(vm.monthly_lease_payment_after_tax / 50) * 50;
                vm.total_msd = vm.msd * vm.msd_selected;
                vm.total_lease_payment_before_tax = vm.term * vm.monthly_lease_payment_before_tax;
                vm.total_lease_payment_after_tax = vm.term * vm.monthly_lease_payment_after_tax;

                // monthly payment breakdown
                vm.monthly_payments_chart = [{
                    name: 'depreciation cost',
                    y: vm.monthly_depreciation
                }, {
                    name: 'financing cost',
                    y: vm.monthly_financing
                },{
                    name: 'tax',
                    y: vm.monthly_tax_charge
                }];
            });

        // Upfront cost
        vm.$watchGroup(['registration_fee', 'plate_fee', 'documentation_fee', 'security_deposit', 'acquisition_fee', 'total_msd', 'monthly_lease_payment_after_tax'],
            function() {
                vm.upfront_gov = vm.registration_fee + vm.plate_fee;
                vm.upfront_dealer = vm.documentation_fee + vm.security_deposit;
                vm.upfront_bank = vm.acquisition_fee;
                vm.upfront_forme = vm.downpayment + vm.monthly_lease_payment_after_tax + vm.total_msd;
                vm.upfront_cost = vm.upfront_gov + vm.upfront_dealer + vm.upfront_bank + vm.upfront_forme;
            });

        // Lease end cost
        vm.$watchGroup(['disposition_fee', 'wear_charge', 'total_msd'],
            function(){
                console.log(vm.total_msd);
                vm.lease_end_charges = vm.disposition_fee + vm.wear_charge;
                vm.lease_end_refund = vm.total_msd + security_refund_rate * vm.security_deposit;
                vm.lease_end_cost = vm.lease_end_charges - vm.lease_end_refund;
            });

        // Cost of ownership
        vm.$watchGroup(['upfront_cost','lease_end_cost'],
            function(){
                vm.cost_of_ownership = vm.upfront_cost + vm.lease_end_cost + vm.total_lease_payment_after_tax - vm.monthly_lease_payment_after_tax;
            });

        // dealer
        vm.dealer_cost_of_capital = 1.5;
        vm.dealer_resale_markup = 25;
        vm.dealer_discount = 14;
        vm.deale_front_cost = 0;

        vm.$watchGroup(['residue_value', 'dealer_resale_markup'],
            function() {
                vm.resale_price = vm.residue_value * (1 + vm.dealer_resale_markup / 100);
            });

        vm.$watchGroup(['upfront_cost', 'invoice', 'dealer_discount'],
            function() {
                vm.dealer_initial_investment = vm.upfront_cost - vm.invoice * (100 - vm.dealer_discount) / 100;
            });

        vm.$watchGroup(['lease_end_cost', 'resale_price'],
            function() {
                vm.dealer_terminal_value = vm.lease_end_cost + vm.resale_price;
            });

        vm.$watchGroup(['dealer_initial_investment', 'dealer_terminal_value', 'term', 'monthly_lease_payment_after_tax'],
            function() {
                // Compute IRR
                var a = new Array();
                a.push(vm.dealer_initial_investment);
                for (i = 0; i < vm.term - 2; i++) {
                    a.push(vm.monthly_lease_payment_after_tax);
                }
                a.push(vm.dealer_terminal_value + vm.monthly_lease_payment_after_tax);
                vm.dealer_cash_flow = a;
                vm.dealer_irr = finance.IRR.apply(this, a);

                // Compute NPV
                var b = a.slice();
                b.unshift(vm.dealer_cost_of_capital);
                vm.dealer_npv = finance.NPV.apply(this, b);
            });

    } // end of controller func
]).component('myinput', {
    bindings: {
        label: '@',
        model: '=',
        type: '@'
    },
    templateUrl: '/app/car-leasing/form_input.hh'
}).component('formheader', {
    bindings: {
        title: '@'
    },
    templateUrl: '/app/car-leasing/form_section_header.hh'
}).component('myvalue', {
    bindings: {
        label: '@',
        model: '<',
        precision: '@',
        type: '@'
    },
    templateUrl: '/app/car-leasing/var_display.hh',
    controller: function() {
        // Decimal points
        var p = parseInt(this.precision);
        if (p > 0) {
            this.decimal_place = p;
        } else {
            this.decimal_place = 2;
        }
    }
}).component('assumption', {
    bindings: {
        label: '@',
        model: '<',
        precision: '@',
        type: '@'
    },
    templateUrl: '/app/car-leasing/assumption_line_item.hh',
    controller: function() {
        // Decimal points
        var p = parseInt(this.precision);
        if (p > 0) {
            this.decimal_place = p;
        } else {
            this.decimal_place = 2;
        }
    }
}).component('piechart', {
    bindings: {
        title: '@',
        data: '<',
        style: '@',
        class: '@'
    },
    templateUrl: '/app/car-leasing/piechart.hh',
    controller: function() {
        var previousValue;

        this.$doCheck = function() {
            var currentValue = this.data && this.data.valueOf();
            if (previousValue !== currentValue) {
                previousValue = currentValue;

                Highcharts.chart('pie', {
                    chart: {
                        plotBackgroundColor: null,
                        plotBorderWidth: 0,
                        plotShadow: false
                    },
                    title: {
                        text: this.title,
                        align: 'center',
                        verticalAlign: 'top',
                        y: 40
                    },
                     tooltip: {
                         pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                     },
                     plotOptions: {
                         pie: {
                             dataLabels: {
                                 enabled: true,
                                 distance: -50,
                                 format: '<b>{point.percentage:.2f}%</b>',
                                 style: {
                                     fontWeight: 'bold',
                                     color: 'white',
                                     textShadow: '0px 1px 2px black'
                                 }
                             },
                             startAngle: -90,
                             endAngle: 90,
                             center: ['50%', '75%'],
                             showInLegend: true
                         }
                     },
                     series: [{
                         type: 'pie',
                         name: this.title,
                         innerSize: '50%',
                         data: this.data
                     }]
                 }); // end of highcharts
             } // end of if
         } // end of doCheck
    } // end of controller
});
