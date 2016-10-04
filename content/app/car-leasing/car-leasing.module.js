// Define the 'carLeasing' module
angular.
module('carLeasing', []).
controller('CarLeasingController', ['$scope',
    function($scope) {
        var vm = $scope;
        var finance = new Finance();

        // constants

        vm.example_msrp = 18881;
        vm.example_residue = 13270;
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
        vm.security_refund_rate = 20;
        vm.monthly_lease_payment_before_tax = 0;
        vm.monthly_lease_payment_after_tax = 0;
        vm.msd = 0;
        vm.disposition_fee = 350;
        vm.wear_charge = 0;

        // Prices and discounts
        vm.$watchGroup(['msrp', 'invoice', 'purchase', 'lease'],
            function() {
                // Discounts from MSRP
                vm.msrp_invoice_discount = (vm.msrp - vm.invoice) / vm.msrp * 100;
                vm.msrp_purchase_discount = (vm.msrp - vm.purchase) / vm.msrp * 100;
                vm.msrp_lease_discount = (vm.msrp - vm.lease) / vm.msrp * 100;

                // Discount from invoice
                vm.invoice_purchase_discount = (vm.invoice - vm.purchase) / vm.invoice * 100;
                vm.invoice_lease_discount = (vm.invoice - vm.lease) / vm.invoice * 100;

                // Assumptions
                vm.deal_term_assumptions = [{
                    name: 'Invoice discount by MSRP',
                    value: vm.msrp_invoice_discount,
                    type: '%'
                }, {
                    name: 'Lease discount by MSRP',
                    value: vm.msrp_lease_discount,
                    type: '%'
                }, {
                    name: 'Lease discount by Invoice',
                    value: vm.invoice_lease_discount,
                    type: '%'
                }];
            });

        // Official lease example
        vm.$watchGroup(['example_msrp', 'example_residue'],
            function() {
                vm.residue = vm.example_residue / vm.example_msrp * 100;
                vm.residue = parseFloat(vm.residue.toFixed(2));

                // Assumptions
                vm.official_example_assumptions = [{
                    name: 'Residue percentage',
                    value: vm.residue,
                    type: '%'
                }];
            });

        // Residue value
        vm.$watchGroup(['msrp', 'residue'],
            function() {
                // Residue value is always computed from MSRP!
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

                // Assumptions
                vm.mf_assumptions = [{
                    name: 'Effective APR',
                    value: vm.actual_apr,
                    type: '%'
                }];
            });

        // Deal
        vm.$watchGroup(['lease', 'sales_tax', 'downpayment', 'rebates', 'credits'],
            function() {
                vm.lease_after_tax = vm.lease * (1 + vm.sales_tax / 100);
                vm.lease_sales_tax = vm.lease_after_tax - vm.lease;
                vm.net_capital_cost = vm.lease_after_tax - vm.downpayment - vm.rebates - vm.credits;
            });

        // Depreciation cost
        vm.$watchGroup(['net_capital_cost', 'residue_value', 'term'],
            function() {
                vm.depreciation_cost = vm.lease - vm.residue_value;
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

                // Taxes
                vm.monthly_tax_charge = vm.monthly_lease_payment_after_tax - vm.monthly_lease_payment_before_tax;
                vm.total_payment_tax = vm.monthly_tax_charge * vm.term;
                vm.total_tax = vm.total_payment_tax + vm.lease_sales_tax;

                // MSD is rounded to the nearest 50
                vm.msd = Math.ceil(vm.monthly_lease_payment_after_tax / 50) * 50;
                vm.total_msd = vm.msd * vm.msd_selected;
                vm.total_lease_payment_before_tax = vm.term * vm.monthly_lease_payment_before_tax;
                vm.total_lease_payment_after_tax = vm.term * vm.monthly_lease_payment_after_tax;

                // monthly payment breakdown
                vm.monthly_payments_chart = [{
                    name: 'Depreciation cost',
                    y: vm.monthly_depreciation
                }, {
                    name: 'Financing cost',
                    y: vm.monthly_financing
                }, {
                    name: 'Tax',
                    y: vm.monthly_tax_charge
                }];

                // Assumptions
                vm.monthly_assumptions = [{
                    name: 'MSD',
                    value: vm.msd,
                    type: '$'
                }, {
                    name: 'Total selected MSD',
                    value: vm.total_msd,
                    type: '$'
                }, {
                    name: 'Total tax from payments',
                    value: vm.total_payment_tax,
                    type: '$'
                }, {
                    name: 'Total sales tax',
                    value: vm.lease_sales_tax,
                    type: '$'
                }, {
                    name: 'Total tax',
                    value: vm.total_tax,
                    type: '$'
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

                // Assumptions
                vm.upfront_cost_assumptions = [{
                    name: 'Walk off cost',
                    value: vm.upfront_cost
                }, {
                    name: 'Government administration fees',
                    value: vm.upfront_gov,
                    type: '$'
                }, {
                    name: 'Dealer fees',
                    value: vm.upfront_dealer,
                    type: '$'
                }, {
                    name: 'Bank fees',
                    value: vm.upfront_bank,
                    type: '$'
                }, {
                    name: 'Used to payoff the deal',
                    value: vm.upfront_forme,
                    type: '$'
                }];
            });

        // Security deposit
        vm.$watchGroup(['security_refund_rate', 'security_deposit'],
            function() {
                vm.security_refund = vm.security_refund_rate / 100 * vm.security_deposit;
            });

        // Lease end cost
        vm.$watchGroup(['disposition_fee', 'wear_charge', 'total_msd', 'security_refund', 'monthly_lease_payment_after_tax'],
            function() {
                vm.lease_end_charges = vm.disposition_fee + vm.wear_charge;
                vm.lease_end_refund = vm.total_msd + vm.security_refund;
                vm.lease_end_cost = vm.lease_end_charges - vm.lease_end_refund + vm.monthly_lease_payment_after_tax;
            });

        // Cost of ownership
        vm.$watchGroup(['upfront_cost', 'lease_end_cost'],
            function() {
                vm.cost_of_ownership = vm.upfront_cost + vm.lease_end_cost + (vm.term - 2) * vm.monthly_lease_payment_after_tax;

                // cost of ownership breakdown
                vm.cost_of_ownership_chart = [{
                    name: 'Walk off cost',
                    y: vm.upfront_cost - vm.monthly_lease_payment_after_tax
                }, {
                    name: 'Lease payments',
                    y: vm.total_lease_payment_after_tax
                }, {
                    name: 'Lease end cost',
                    y: vm.lease_end_cost - vm.monthly_lease_payment_after_tax
                }];
            });


        // dealer
        vm.dealer_cogs = 20000;
        vm.dealer_cost_of_capital = 1.5;
        vm.dealer_resale_markup = 25;
        vm.dealer_ownership_resale = 100;

        vm.$watchGroup(['residue_value', 'dealer_resale_markup', 'dealer_ownership_resale'],
            function() {
                vm.resale_price = vm.residue_value * (1 + vm.dealer_resale_markup / 100);
                vm.dealer_resale_value = vm.resale_price * vm.dealer_ownership_resale /100;
            });

        vm.$watchGroup(['dealer_cogs', 'msrp', 'invoice', 'resale_price'],
            function(){
                vm.dealer_cogs_msrp_discount = (vm.msrp - vm.dealer_cogs)/vm.msrp*100;
                vm.dealer_cogs_invoice_discount = (vm.invoice - vm.dealer_cogs)/vm.invoice*100;

                // Assumptions
                vm.dealer_assumptions = [{
                    name: 'Resale price',
                    value: vm.resale_price,
                    type: '$'
                },{
                    name: "Dealer's COGS discount by Invoice",
                    value: vm.dealer_cogs_invoice_discount,
                    type: '%'
                },{
                    name: "Dealer's' COGS discount by MSRP",
                    value: vm.dealer_cogs_msrp_discount,
                    type: '%'                }];
            });

        vm.$watchGroup(['upfront_cost', 'dealer_cogs', 'lease_sales_tax'],
            function() {
                vm.dealer_initial_investment = vm.upfront_cost - vm.dealer_cogs - vm.lease_sales_tax - vm.upfront_gov - vm.upfront_bank - vm.monthly_tax_charge;
            });

        vm.$watchGroup(['lease_end_cost', 'dealer_resale_value'],
            function() {
                vm.dealer_terminal_value = vm.lease_end_cost + vm.dealer_resale_value - vm.monthly_tax_charge;
            });

        vm.$watchGroup(['dealer_initial_investment', 'dealer_terminal_value', 'dealer_cost_of_capital'],
            function() {
                // Compute IRR
                var a = new Array();
                a.push(vm.dealer_initial_investment);
                for (i = 0; i < vm.term - 2; i++) {
                    a.push(vm.monthly_lease_payment_before_tax);
                }
                a.push(vm.dealer_terminal_value);
                vm.dealer_cash_flow = a;
                if (vm.dealer_initial_investment < 0){
                    // IRR is only valid when there is a negative initial investment
                    vm.dealer_irr = finance.IRR.apply(this, a);
                }else{
                    // Set to undefined
                    vm.dealer_irr = (function () { return; })();
                }

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
        type: '@',
        max: '@',
        min: '@',
        step: '@'
    },
    templateUrl: '/app/car-leasing/form_input.hh',
    controller: function(){
        // Decimal points
        if (this.min) {
            this.min = parseInt(this.min);
        } else {
            this.min = 0;
        }
    }
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
}).component('assumptions', {
    bindings: {
        id: '@',
        values: '<'
    },
    templateUrl: '/app/car-leasing/assumption.hh',
}).component('summary', {
    bindings: {
        label: '@',
        model: '<',
        precision: '@',
        type: '@'
    },
    templateUrl: '/app/car-leasing/summary_line_item.hh',
    controller: function() {
        // Decimal points
        var p = parseInt(this.precision);
        if (p >= 0) {
            this.decimal_place = p;
        } else {
            this.decimal_place = 2;
        }
    }
}).component('piechart', {
    bindings: {
        id: '@',
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

                Highcharts.chart(this.id, {
                    chart: {
                        plotBackgroundColor: null,
                        plotBorderWidth: 0,
                        plotShadow: false
                    },
                    title: {
                        text: this.title,
                        align: 'center',
                        verticalAlign: 'top',
                        y: 25
                    },
                    tooltip: {
                        pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>'
                    },
                    plotOptions: {
                        pie: {
                            dataLabels: {
                                enabled: true,
                                format: '<b>{point.percentage:.0f}%</b>'
                            },
                            startAngle: -90,
                            endAngle: 90,
                            center: ['50%', '85%'],
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
