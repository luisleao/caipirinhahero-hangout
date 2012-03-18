
var serverPath = '//caipirinha-hangout.appspot.com/';
var notes = [];
var playing = false;
var total_notas = 32;


var musica = [];
var id_notas = ["do", "re", "mi", "fa", "sol", "la", "si"];
var num_notas = [32, 32, 32, 32, 32, 32, 32, 32];





var my_id = null;


var forbiddenCharacters = /[^a-zA-Z!0-9_\- ]/;
function setText(element, text) {
  element.innerHTML = typeof text === 'string' ?
      text.replace(forbiddenCharacters, '') :
      '';
}


function updateStateUi(state) {
		
	// percorre notas e define status de cada nota
	for (var i=0; i<id_notas.length; i++) {
		var nome_nota = id_notas[i];
		var tabela = [];
		for (var j=0; j<num_notas[i]; j++) {
			if (state[nome_nota + "_" + j]) {
				var active = parseInt(state[nome_nota + "_" + j] && state[nome_nota + "_" + j] || "0");
				if (active) {
					$("#" + nome_nota + " li:eq("+(j+1)+")").addClass("active");
				} else {
					$("#" + nome_nota + " li:eq("+(j+1)+")").removeClass("active");
				}
			}
		}
	}


}

function pushUpdates() {
	// verificar velocidade
	if (!my_id)
		return;
	
	//console.log("PUSHING UPDATE");
	$.ajax({
		url: serverPath + "push/" + my_id + "/",
		context: document.body,
		dataType: "json",
		data: {
			"sequencia": JSON.stringify(notes),
			"play": playing ? "1" : "0"
		}
	});
	
}


function buttonClick(e) {
	e.preventDefault();
	

	var linha = $(this).parent("ul").attr("id");	
	var index = $(this).index() - 1;
	var active = $(this).hasClass("active");
	
	//console.log("CLICK " + linha + " " + index);
	
	var dicionario = {};
	dicionario[linha + "_" + index] = !active ? "1" : "0";
	gapi.hangout.data.submitDelta(dicionario);
	
	
	// fazer push das notas
	$.ajax({
		url: serverPath + "push/" + linha + "/" + index  + "/" + dicionario[linha + "_" + index] + "/",
		context: document.body,
		dataType: "json",
		data: {
			"sequencia": JSON.stringify(notes),
			"play": playing ? "1" : "0"
		}
	});

}




// A function to be run at app initialization time which registers our callbacks
function init() {
  //console.log('Init app.');
  
  var apiReady = function(eventObj) {
    if (eventObj.isApiReady) {
      //console.log('API is ready');

      gapi.hangout.data.onStateChanged.add(function(eventObj) {
        updateStateUi(eventObj.state);
      });
	  
	  my_id = gapi.hangout.getParticipantById(gapi.hangout.getParticipantId()).person.id;

      updateStateUi(gapi.hangout.data.getState());
      gapi.hangout.onApiReady.remove(apiReady);

    }
  };

  // This application is pretty simple, but use this special api ready state
  // event if you would like to any more complex app setup.
  gapi.hangout.onApiReady.add(apiReady);
}

gadgets.util.registerOnLoadHandler(init);




$(document).ready(function(){

	// inicializar tabela da musica
	for (var i=0; i<id_notas.length; i++) {
		var tabela = [];
		for (var j=0; j<num_notas[i]; j++) {
			tabela.push(0);
		}
		musica.push(tabela);
	}
	
	//inicializar click dos botoes
	$("#buttons li").not(".title").click(buttonClick);
	

});