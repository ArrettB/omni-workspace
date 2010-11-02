function handleChange(country) {

    var stateElement = document.getElementById("state");
    var destinationStateElement = document.getElementById("destinationState");
    var provinces = '<option value="AB">AB</option><option value="BC">BC</option><option value="MB">MB</option><option value="NB">NB</option><option value="NL">NL</option><option value="NS">NS</option><option value="NT">NT</option><option value="NU">NU</option><option value="ON">ON</option><option value="PE">PE</option><option value="QC">QC</option><option value="SK">SK</option><option value="YT">YT</option>';
    var states = '<option value="AK">AK</option><option value="AL">AL</option><option value="AR">AR</option><option value="AZ">AZ</option><option value="CA">CA</option><option value="CO">CO</option><option value="CT">CT</option><option value="DC">DC</option><option value="DE">DE</option><option value="FL">FL</option><option value="GA">GA</option><option value="HI">HI</option><option value="IA">IA</option><option value="ID">ID</option><option value="IL">IL</option><option value="IN">IN</option><option value="KS">KS</option><option value="KY">KY</option><option value="LA">LA</option><option value="MA">MA</option><option value="MD">MD</option><option value="ME">ME</option><option value="MI">MI</option><option value="MN">MN</option><option value="MO">MO</option><option value="MS">MS</option><option value="MT">MT</option><option value="NC">NC</option><option value="ND">ND</option><option value="NE">NE</option><option value="NH">NH</option><option value="NJ">NJ</option><option value="NM">NM</option><option value="NV">NV</option><option value="NY">NY</option><option value="OH">OH</option><option value="OK">OK</option><option value="OR">OR</option><option value="PA">PA</option><option value="RI">RI</option><option value="SC">SC</option><option value="SD">SD</option><option value="TN">TN</option><option value="TX">TX</option><option value="UT">UT</option><option value="VA">VA</option><option value="VT">VT</option><option value="WA">WA</option><option value="WI">WI</option><option value="WV">WV</option><option value="WY">WY</option>';
    var canadaRE = /^CA/i;

    if (canadaRE.test(country)) {
        select_innerHTML(stateElement, provinces);
        select_innerHTML(destinationStateElement, provinces);
    }
    else {
        select_innerHTML(stateElement, states);
        select_innerHTML(destinationStateElement, states);
    }
}

function select_innerHTML(objeto, innerHTML) {
    /******
     * select_innerHTML - innerHTML to add option(s) to select(s)
     * Problem: http://support.microsoft.com/default.aspx?scid=kb;en-us;276228
     * Creative Commons license
     * Vers‹o: 1.0 - 06/04/2006
     * Author: Micox - N‡iron J.C.G - micoxjcg@yahoo.com.br - elmicoxcodes.blogspot.com
     * Parametros:
     * objeto(tipo object): the select
     * innerHTML(tipo string): the new innerHTML
     *******/
    objeto.innerHTML = "";
    //creating phantom element to receive temp innerHTML
    var selTemp = document.createElement("micoxselect");
    var opt;
    selTemp.id = "micoxselect1";
    document.body.appendChild(selTemp);
    selTemp = document.getElementById("micoxselect1");
    selTemp.style.display = "none";
    if (innerHTML.toLowerCase().indexOf("<option") < 0) {//if not option, convert do option
        innerHTML = "<option>" + innerHTML + "</option>"
    }

    innerHTML = innerHTML.replace(/<option/g, "<span").replace(/<\/option/g, "</span");
    selTemp.innerHTML = innerHTML;

    //transfering childs of phantom element to options
    for (var i = 0; i < selTemp.childNodes.length; i++) {
        if (selTemp.childNodes[i].tagName) {
            opt = document.createElement("OPTION");
            for (var j = 0; j < selTemp.childNodes[i].attributes.length; j++) {
                opt.setAttributeNode(selTemp.childNodes[i].attributes[j].cloneNode(true))
            }
            opt.value = selTemp.childNodes[i].getAttribute("value");
            opt.text = selTemp.childNodes[i].innerHTML;
            if (document.all) { //IEca
                objeto.add(opt)
            }
            else {
                objeto.appendChild(opt)
            }
        }
    }
    //clear phantom
    document.body.removeChild(selTemp);
    selTemp = null
}