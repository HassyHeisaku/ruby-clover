/* tagcloud filter */
window.addEventListener('DOMContentLoaded', function() {
  var t_value = location.search.split('=')[1];
  tag_place = document.getElementById("tagcloud")
  for(tag in tag_map){
	  if(t_value){
		  t_value = decodeURI(t_value);
		  current_tag[tag] = false;
	  }else{
		  current_tag[tag] = true;
	  }
    Array.prototype.push.apply(all_ids,tag_map[tag]); 
  }
  all_ids = all_ids.sort().filter(function (x, i, self) { return self.indexOf(x) === i; });
  calc_tag_weight();
  add_tagcloud(current_tag);
  if(t_value){ 
    dummy = document.createElement('p');
    dummy.textContent = t_value;
    filter_it(dummy);
  }
});

var current_tag = {};
var all_ids = [];
var visible_ids = [];
var tag_place;
var tag_weight = {};

function calc_tag_weight(){
  var max_count = Math.max.apply(null,Object.values(tag_map).map(function(v){return v.length;}));
  for(t in tag_map){
   tag_weight[t] = "tag" + Math.floor(10 * tag_map[t].length/max_count).toString();
  }
}

function add_tagcloud(current_tag){
  for(tag in current_tag){
    var tag_element = document.createElement('li');
    tag_element.textContent = tag;
    tag_element.className = tag_weight[tag];
    tag_element.onclick = function(){filter_it(this)};
    tag_element.style.cursor = "pointer";
    if(current_tag[tag]){tag_element.style.color = "blue";}else{ tag_element.style.color = "#aaaaaa";}
    tag_place.appendChild(tag_element);
  }
}
function lists_to_list(contents_list){
  return Array.prototype.concat.apply([], contents_list).sort().filter(function (x, i, self) { return self.indexOf(x) === i; });
}
function filter_it(clicked_element){
    tag = clicked_element.textContent;
    current_tag[tag] = !current_tag[tag];
    if(current_tag[tag] == true){
      visible_ids = visible_ids.concat(tag_map[tag]).sort().filter(function(x,i,self){ return self.indexOf(x) === i;});
    }else{
      visible_ids = visible_ids.filter(i => tag_map[tag].indexOf(i) == -1);
    }
    for(tag in tag_map){ current_tag[tag]=false; }
    for(tag in tag_map){ 
      for(var i=0;i<visible_ids.length;i++){
        if(tag_map[tag].indexOf(visible_ids[i]) != -1){
          current_tag[tag]= true;
          break;
        }
      }
    }
    tag_place.textContent = null;
    add_tagcloud(current_tag);
    all_ids.forEach(function(val,index){document.getElementById(val).style.display = 'none'});
    visible_ids.forEach(function(val,index){
      document.getElementById(val).style.display = 'block';
    });
};
