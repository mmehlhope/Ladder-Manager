define(['jquery', 'underscore'],  function($, _){

  /* Credit to Kyle Jacobson for roughly this entire file.
   * I shameless ripped this until I replace it with something custom-made
   * because it is so awesome.
  */
  var util = {
      /**
       * This is just a wrapper for console.log(), so we can leave
       * log statements in the code without blowing up if the
       * console isn't installed/enabled.
       *
       * In many browsers, log() takes a variable number of arguments
       * so you can mix strings and objects in the same log
       * statement, etc.
       *
       * @param {String|Number|Object, [String|Number|Object]...}
       *        Whatever you want log
       */
    log: function(arg_list) {
        try {
          // console is a host object, and its methods are not required
          // to inherit from Function
          if (console.log.apply) {
            console.log.apply(console, arguments);
          } else {
            var args = Array.prototype.slice.call(arguments);
            console.log(args.join(' '));
          }
        }
        catch(err) {

        }
    },

    createCookie: function(name,value,days) {
        if (days) {
            var date = new Date();
            date.setTime(date.getTime()+(days*24*60*60*1000));
            var expires = "; expires="+date.toGMTString();
        }
        else var expires = "";
        document.cookie = name+"="+value+expires+"; path=/";
    },
    readCookie: function(name) {
        var nameEQ = name + "=";
        var ca = document.cookie.split(';');
        for(var i=0;i < ca.length;i++) {
            var c = ca[i];
            while (c.charAt(0)==' ') c = c.substring(1,c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
        }
        return null;
    },
    eraseCookie: function(name) {
        util.createCookie(name,"",-1);
    },

    disableForm: function(f){
      f = $(f);
      f.find('input').add('textarea', f).add('select', f).attr('disabled', 'disabled');
    },

    enableForm: function(f){
      $(f).find('input').add('textarea', f).add('select', f).removeAttr('disabled');
    },

    alertJsonError: function(transport, defaultMessage, preamble) {
      var json = transport.responseText,
          message;
      try {
        json = JSON.parse(json);
      } catch (e) { }
      if (json && json.errors) {
        message = "Errors: " + json.errors.join("; ");
      } else if (json && json.error) {
        message = json.error;
      } else {
        message = defaultMessage;
      }
      alert(preamble ? (preamble + ' ' + message) : message);
    },

    isBlank: function(string) {
      return !string || /^\s*$/.test(string);
    },

    // TODO make this a proper jQuery iterator by handling +this+
    isFieldCheckedOrNonBlank: function(el) {
      var el = $(el);
      return (el.is(':checkbox') && el.is(':checked')) || (el.is(':text') && el.val() != '');
    },

    // convertErrorObjToArr: function(errObject) {
    //   errorArray = []
    //   for (var key in errObject) {
    //     errorArray.push(errObject[key].toString().capitalize().
    //   }
    // },
    parseErrorResponse: function(errors, options) {
        var errs;
        if (_.isArray(errors)) {
            errs = errors;
        } else
        if (_.isString(errors)) {
            errs = [errors];
        } else {
            errs = util.parseTransportErrors(errors, options);
        }
        return errs;
    },

    parseTransportErrors: function(transport, options) {
      var defaultMessage = (options && options.defaultMessage) || "The operation failed. Try again later.",
          errors = null,
          json;

      if (transport.responseText) {
        try {
          json = JSON.parse(transport.responseText);
          if (json.errors) {
            errors = json.errors;
          } else if (json.error) {
            errors = [json.error];
          }
        } catch (e) { }
      }
      if (!errors || errors.length == 0) {
        // Checking to see if the error was generated due to an aborted connection while the
        // browser is navigating
        if (!(transport && transport.status == 0 && window.navigating && window.navigating == true)) {
            errors = [defaultMessage];
        }
      }

      return errors;
    },

    spin: function(e, srcimg){
      var img = $('<img/>');
      if(!srcimg) {
          srcimg = $('img#spinner');
      }
      e.hide();
      img.attr('src', srcimg.attr('src'));
      e.after(img);
    },

    unspin: function(e){
      e.show();
      e.siblings('img').remove();
    },

    splitUrl: function(url){
      var resource = url,
          params = {},
          ret = [],
          queryString, i;
      if((i=url.indexOf('?')) >= 0){
        resource = url.slice(0, i);
        queryString = url.slice(i+1);
        ret.push(resource,util.queryParams(queryString));
      }else{
        ret.push(resource);
      }

      return ret;
    },

    queryParams: function(queryString) {
      queryString = decodeURIComponent(queryString);
      var query = queryString.replace(/^[^\?]*\?/,'').replace(/\#.*$/,'').split('&'),
          params = {},
          i, k, n, v;
      for(i=0; i<query.length; i++){
        if((k=query[i].indexOf('=')) >= 0) {
          n = query[i].slice(0,k);
          v = query[i].slice(k+1);
          params[n]=v;
        } else {
          params[query[i]] = null;
        }
      }
      return params;
    },

    queryString: function(params){
      var keyVals;
      if(params && !($.isEmptyObject(params))){
        keyVals = $.map(params, function(val, key){
          key = encodeURIComponent(key)
          if(val === null){
            return key;
          }else{
            return "" + key + '=' + encodeURIComponent(val);
          }
        });
        return "?" + keyVals.join("&");
      }else{
        return "";
      }
    },

    joinUrl: function(path, params){
      var url = path,
          qs = util.queryString(params);
      if(qs){ url += qs; }
      return url;
    },

    // given a date string with a timezone offset
    // adjust the date so it renders as if in that timezone,
    // even though the JS Date object will be in the locale tz
    dateInTz: function(datestring){
      var d = new Date(datestring),
          delta,
          ret,
          offsetFromDateString = function(datestring) {
            var offsetRegex = /([+-])(\d\d)(\d\d)$/,
                matches = datestring.match(offsetRegex),
                minutes;
            if(matches){
                minutes = parseInt(matches[2], 10) * 60;
                minutes = minutes + parseInt(matches[3], 10);
                // JS offsets are opposite the normal sign,
                // i.e. they are what you need to add to local time
                // to get UTC, in minutes
                return minutes * (matches[1] == '-' ? 1 : -1);
            }
          },
          serverOffset = offsetFromDateString(datestring);

      if(d.getTimezoneOffset() == serverOffset) {
        ret = d;
      } else {
        delta = d.getTimezoneOffset() - serverOffset;
        ret = new Date(d.getTime() + delta * 60000);
      }
      return ret;
    },

    dateTimeTzStr: function(datestring){
      var d = util.dateInTz(datestring),
          s = d.toLocaleDateString() + " " + d.getHours() + ":",
          mins = "" + d.getMinutes();

      if(mins.length == 1) {
          mins = "0" + mins;
      }
      return s + mins;
    },

    // Obtain a valid regexp to parse dates
    dateValidationRegExp: function(type) {
      var regex;
      switch(type) {
        // 01-01-2013
        case "dashes":
          regex = new RegExp(/(0[1-9]|1[012])[-](0[1-9]|[12][0-9]|3[01])[-](19|20)\d\d/g);
          break;
        // 01 01 2013
        case "spaces":
          regex = new RegExp(/(0[1-9]|1[012])[ ](0[1-9]|[12][0-9]|3[01])[ ](19|20)\d\d/g);
          break;
        // 01/01/2013
        case "slashes":
          regex = new RegExp(/(0[1-9]|1[012])[/](0[1-9]|[12][0-9]|3[01])[/](19|20)\d\d/g);
          break;
        // 01.01.2013
        case "dots":
          regex = new RegExp(/(0[1-9]|1[012])[.](0[1-9]|[12][0-9]|3[01])[.](19|20)\d\d/g);
          break;
        default:
        // Any combination of separator
          regex = new RegExp(/(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d/g);
          break;
      }
      return regex;
    },

    /* Returns the user timezone offset for ISO8601 (ex: +08:00) */
    _dateTzOffsetIso: function() {
      var local = new Date(),
          tzo = -local.getTimezoneOffset(),
          tzoAbs = Math.abs(Math.floor(tzo)),
          tzoSign = tzo >= 0 ? '+' : '-';
      return tzoSign + this.zeroPad(tzoAbs / 60, 2) + ':' + this.zeroPad(tzoAbs % 60, 2);
    },

    /* Returns first second of the day in user timezone (ISO8601 format) */
    dateStartOfDayIsoStr: function(date) {
      return date + 'T00:00:00' + this._dateTzOffsetIso()
    },

    /* Returns last second of the day in user timezone (ISO8601 format) */
    dateEndOfDayIsoStr: function(date) {
      return date + 'T23:59:59' + this._dateTzOffsetIso()
    },

    /* Get rid of T23:59:59-08:00 */
    stripTimeIso: function(date) {
      return date.replace(/T\d\d:\d\d:\d\d(-|\+)\d\d:\d\d/g, '');
    },

    // came from here: https://gist.github.com/sulf/1157909
    // made some improvements. KSJ
    distanceOfTimeInWords: function(from_time, to_time, include_seconds) {
      var from_year,
          from_month,
          to_year,
          to_month,
          distance_in_minutes,
          distance_in_seconds,
          distance_in_years,
          minute_offset_for_leap_year,
          remainder,
          year_num,
          year_floor,
          ret;
      to_time || (to_time = 0);
      from_time = new Date(from_time);
      to_time = new Date(to_time);
      distance_in_minutes = Math.round(Math.abs(to_time - from_time) / 60 / 1000);
      distance_in_seconds = Math.round(Math.abs(to_time - from_time) / 1000);
      if (0 <= distance_in_minutes && distance_in_minutes <= 1) {
          if (!include_seconds) {
              if (distance_in_minutes === 0) {
                  ret = "less than 1 minute";
              } else if (distance_in_minutes === 1) {
                  ret = "1 minute";
              } else {
                  ret = distance_in_minutes + " minutes";
              }
          } else if (0 <= distance_in_seconds && distance_in_seconds <= 4) {
              ret = "less than 5 seconds";
          } else if (5 <= distance_in_seconds && distance_in_seconds <= 9) {
              ret = "less than 10 seconds";
          } else if (10 <= distance_in_seconds && distance_in_seconds <= 19) {
              ret = "less than 20 seconds";
          } else if (20 <= distance_in_seconds && distance_in_seconds <= 39) {
              ret = "less than half a minute";
          } else if (40 <= distance_in_seconds && distance_in_seconds <= 59) {
              ret = "less than 1 minute";
          } else {
              ret = "1 minute";
          }
      } else if (2 <= distance_in_minutes && distance_in_minutes <= 44) {
          ret = distance_in_minutes + " minutes";
      } else if (45 <= distance_in_minutes && distance_in_minutes <= 89) {
          ret = "about 1 hour";
      } else if (90 <= distance_in_minutes && distance_in_minutes <= 1439) {
          ret = "about " + (Math.round(distance_in_minutes / 60.0)) + " hours";
      } else if (1440 <= distance_in_minutes && distance_in_minutes <= 2529) {
          ret = "1 day";
      } else if (2530 <= distance_in_minutes && distance_in_minutes <= 43199) {
          ret = (Math.round(distance_in_minutes / 1440.0)) + " days";
      } else if (43200 <= distance_in_minutes && distance_in_minutes <= 86399) {
          ret = "about 1 month";
      } else if (86400 <= distance_in_minutes && distance_in_minutes <= 496799) {
          ret = + (Math.round(distance_in_minutes / 43200.0)) + " months";
      } else {
          from_year = from_time.getFullYear();
          from_month = from_time.getMonth();
          to_year = to_time.getFullYear();
          to_month = to_time.getMonth();
          distance_in_years = distance_in_minutes / 525600;
          minute_offset_for_leap_year = 0;
          if (from_year % 4 === 0 && (from_month < 2 || (from_month == 2 && from_time.getDate() < 29))) {
              // there was a leap day in the starting year of our range
              minute_offset_for_leap_year += 1440;
          }
          if (to_year % 4 === 0 && to_month > 2) {
              // we've passed a leap day in the current year
              minute_offset_for_leap_year += 1440;
          }
          for (var i = to_year-1; i > from_year; i--) {
              if (i % 4 === 0) {
                  minute_offset_for_leap_year += 1440;
              }
          }
          //minute_offset_for_leap_year = (distance_in_years / 4) * 1440;
          remainder = (distance_in_minutes - minute_offset_for_leap_year) % 525600;
          year_num = Math.round(distance_in_years);
          year_floor = (Math.floor(distance_in_years));

          if (remainder < 131400) {
              ret = "about " + year_num + " year"+(year_num != 1 ? 's' : '');
          } else if (remainder < 394200) {
              ret = "over " + year_floor + " year"+(year_floor != 1 ? 's' : '');
          } else {
              ret = "almost " + year_num + " year"+(year_num != 1 ? 's' : '');
          }
      }
      return ret;
    },

    parseDateTimeStr: function(datetimeStr){
      var dateTimeArr, date, time, utcOffset, dateArr, year, month, day, dateResult;
      if (!datetimeStr) return;

      dateTimeArr = datetimeStr.split(' ');
      date = dateTimeArr[0];
      time = dateTimeArr[1];
      utcOffset = dateTimeArr[2];

      dateArr = date.split('/');
      year = dateArr[0];
      month = dateArr[1];
      day = dateArr[2];

      dateResult = [month, day, year].join('-');
      return [dateResult, time];
    },

    viewportOffset: function(item){
      var win = $(window);
      var offset = $(item).offset();
      return {
        left: offset.left - win.scrollLeft(),
        top: offset.top - win.scrollTop()
      };
    },

    /* Modified version of http://stackoverflow.com/questions/10420352 */
    numberToHumanSize: function (bytes) {
      var i = -1;
      var byteUnits = [' KB', ' MB', ' GB', ' TB', ' PB', ' EB', ' ZB', ' YB'];
      do {
        bytes /= 1024;
        i++;
      } while (bytes >= 1024);
      return (Math.max(bytes, 0.1).toFixed(1) + byteUnits[i]).replace(/\.0/, '');
    },

    /* Returns null if either a1 or a2 is not an array, true if all elements in a1 can be found in a2, false otherwise */
    sameArray: function (a1, a2) {
      if (_.isArray(a1) && _.isArray(a2)) {
        return (a1.length === a2.length && _.intersection(a1, a2).length === a1.length);
      }
      return null;
    },

    fileExtension: function(fileName) {
      return fileName.indexOf('.') === -1 ? null : fileName.split('.').pop().toLowerCase();
    },

    scrollToTop: function() {
      if (window && window.scrollTo) {
        return window.scrollTo(0,0);
      }
    },

    enable: function($obj) {
      this.disable($obj, false);
    },

    disable: function($obj, bool) {
      var bool = (bool === undefined) ? true : bool;
      $obj.toggleClass("disabled", bool);
      // Do not set the disabled attribute for links. Multiple reasons for this:
      // - inconsistent behaviors across browsers
      // - ignore custom event handlers BUT honor default ones (will follow # if set in the href for example)
      // (also see APP-11545)
      if (!$obj.is('a')) $obj.prop("disabled", bool);
    },

    zeroPad: function(num, size) {
      return size ? ('000000000' + num).slice(-size) : num;
    }
  };

  return util;
});
