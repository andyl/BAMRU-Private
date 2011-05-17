function lengthLimit(field, visibleCount, max) {
  if (field.value.length > max) {
    field.value = field.value.substring(0, max);
  }
  visibleCount.innerHTML = max - field.value.length;
}

function editWin(url) {
  window.open(url,'edit','width=400,height=320,status=yes,location=no');
}

function selectMembers(val,list) {

  if (val==false) {     var checked_types = [];         var id_lookup = [];             var caller_id_lookup = [];      for (i_=0; i_ < array_list.length; i_++) {
    id_lookup[i_]= [];
  }
    for (i_=0;i_<array_list.length;i_++) {
      if (document.roster.elements["contact_leaders" + i_]) {
        var one_row = array_list[i_];
        if (document.roster.elements["contact_leaders" + i_].checked == true) {
          checked_types[i_] = true;
          for (var j_=0;j_<one_row.length;j_++) {
            id_lookup[i_][one_row[j_]] = true;
          }
        } else if (one_row == list) {
          for (var j_=0;j_<one_row.length;j_++) {
            caller_id_lookup[one_row[j_]] = true;
          }
        }
      }
    }
    var dont_uncheck = [];
    for (i_=0,n_=document.roster.elements.length;i_<n_;i_++) {
      if (document.roster.elements[i_].type == 'checkbox' && document.roster.elements[i_].checked == true && document.roster.elements[i_].name.substr(0,15) != "contact_leaders") {
        object_number = document.roster.elements[i_].name.substr(6);
        if (caller_id_lookup[object_number]) {
          for (var j_=0;j_<array_list.length;j_++) {
            if (checked_types[j_]) {
              var one_row = array_list[j_];
              if (id_lookup[j_][object_number] == true) {
                //item is checked and still has a group checked. don't uncheck it.
                dont_uncheck[object_number] = true;
              }
            }
          }
        }
      }
    }
  }
  for(var i_=0;i_<list.length;i_++) {
    if (val==true || (val==false && ! dont_uncheck[list[i_]])) {
      name = "email_" + list[i_];
      if (document.roster.elements[name]) {
        window.document.roster.elements[name].checked = val;
      }
      name = "pager_" + list[i_];
      if (document.roster.elements[name]) {
        document.roster.elements[name].checked = val;
      }
    }
  }
}

tm = new Array(0,22,30,11,100,20,78);

fm = new Array(0,35,3,26,92,32,94,65,87,103,71,79,82,70,83,68,81,27,72);

t = new Array(0,125,124,111,88,104,127,122,112,119,113,107,116,95,114,115,121,109,62,118,110,117,98,96,91,126,99,108);

r = new Array(0,105,77,69,76,89,34,5,41,67,9,90,86,28);

s = new Array(0,123,85,84);

a = new Array(0,24,19,75,1,18,120);

ol = new Array(0,94,30,35,26,22,65,11,79,78,20,72,92,70,81,87,103,82);

bd = new Array(0,87,79,22,92,82);

array_list = new Array(tm,fm,t,r,s,a,ol,bd);
