/**
 * @constructor
 * @extends {ol.control.Control}
 * @param {Object=} opt_options Control options.
 */
var ZoomDisplay = function(opt_options) {
  var options = opt_options || {},
      form = document.createElement('form'),
      i,
      input,
      field,
      self = this;

  /*
  field = document.createElement('h1');
  field.innerHTML = "Ebenen";
  form.appendChild(field);

  for(i = 0; i<layers.length; i++){
    field = document.createElement('p');
    field.innerHTML = layers[i].title;
    input = document.createElement('input');
    input.setAttribute('type','checkbox');
    input.setAttribute('name','layerswitcher-'+layers[i].style);
    input.setAttribute('value',layers[i].style);
    if (layers[i].visible){
      input.setAttribute('checked','checked');
    }
    input.targetLayer = layers[i].layer;
    input.addEventListener('change',function(evt){
      for(var i = 0; i<layers.length; i++){
        if (layers[i].style === evt.srcElement.defaultValue){
          layers[i].layer.setVisible(evt.srcElement.checked);
        }
      }
    });
    field.appendChild(input);
    form.appendChild(field);
  }
  */

  var element = document.createElement('div');
  element.className = 'ol-zoomdisplay ol-unselectable ol-control';

  field = document.createElement('p');
  element.appendChild(field);


  ol.control.Control.call(this, {
    element: element,
    target: options.target
  });

  window.setTimeout(function(){
    self.getMap().on('moveend', function(evt){
      field.innerHTML = "Zoom: "+evt.map.getView().getZoom();
    });
  },2000);

};

ol.inherits(ZoomDisplay, ol.control.Control);
