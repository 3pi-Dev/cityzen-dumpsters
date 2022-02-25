angular.module('smartMeters').filter("fDate", function($filter) {

	return function(input, format) {
		var d = new Date(input);
		d = $filter('date')(d, format);
		return d;
	};
});

Date.prototype.addDays = function(days) {
    this.setDate(this.getDate() + parseInt(days));
    return this;
};
Date.prototype.addHours = function(hours) {
    this.setHours(this.getHours() + parseInt(hours));
    return this;
};