const G_N = 8;
const G_D = 120/G_N;

const B_N = 10;
const B_S = [0,1,2,3,4,5,6,7,8,9];
const B_C = Array(B_S.length)


let DATA = [];

let write = false;

// const canvas = document.getElementById('sketchpad');
// const context = canvas.getContext('2d');
if(localStorage.uuid == undefined){
    localStorage.clear();
    localStorage.uuid = crypto.randomUUID().substring(32) + "-" + prompt("Hello! Enter a memorable name to identify your dataset:");
}
else{
    if(localStorage.data){
        DATA = JSON.parse(localStorage.data);
    }
}

window.addEventListener('load', function () {
    populate();

    for(let i=0; i<B_N; i++){
        let canvas = $(`c${i}`);
        let context = canvas.getContext('2d', { willReadFrequently: true });    
        var isIdle = true;
        context.lineWidth = 8.0;
    
        // https://stackoverflow.com/questions/16057256/draw-on-a-canvas-via-mouse-and-touch
        function drawstart(event) {
            context.beginPath();
            context.moveTo(event.pageX - canvas.getBoundingClientRect().left, event.pageY - canvas.getBoundingClientRect().top);
            isIdle = false;
        }
        function drawmove(event) {
            if (isIdle) return;
            context.lineTo(event.pageX - canvas.getBoundingClientRect().left, event.pageY - canvas.getBoundingClientRect().top);
            context.stroke();
        }
        function drawend(event) {
            if (isIdle) return;
            drawmove(event);
            isIdle = true;
        }
        function touchstart(event) { drawstart(event.touches[0]) }
        function touchmove(event) { drawmove(event.touches[0]); event.preventDefault(); }
        function touchend(event) { drawend(event.changedTouches[0]) }
      
        canvas.addEventListener('touchstart', touchstart, false);
        canvas.addEventListener('touchmove', touchmove, false);
        canvas.addEventListener('touchend', touchend, false);        
      
        canvas.addEventListener('mousedown', drawstart, false);
        canvas.addEventListener('mousemove', drawmove, false);
        canvas.addEventListener('mouseup', drawend, false);
      
        grid(i);
    }
}, false);

function $(x){
    return document.getElementById(x);
}

let str = [];
for(let i=0; i<G_N**2; i++){
    str.push(`<div class="l-grid" style="top: ${Math.floor(i/G_N)*G_D}px; left: ${i%G_N*G_D}px; width: ${G_D}px; height: ${G_D}px"></div>`)
}
const G_S = str.join("");

function grid(n){
    $(`g${n}`).innerHTML += G_S;
}
function clean(n){
    $(`c${n}`).getContext('2d').clearRect(0, 0, 120, 120);
    if(B_C[n]){
        verify(n); 
    }
}
function print(n){
    let context = $('c' + n).getContext('2d')
    let arr = [];
    let info = [];
    arr.push(n)
    for(let i=0; i<G_N**2; i++){
        info = context.getImageData(i%G_N*G_D, Math.floor(i/G_N)*G_D, G_D, G_D).data;

        let sum = 0;
        for(let j=0; j<info.length/4; j++){
            sum += info[j*4+3];
        }
        arr.push(4*sum/(info.length*255));
    }
    console.log(arr);
    return arr;
}

function populate(){
    str = [];
    for(let i=0; i<B_N; i++){
        str.push(`
                <div class="draw-wrap">
                    <div id="g${i}"></div>
                    <canvas id="c${i}" height="120px" width="120px"></canvas>
                    <canvas id="c${i+B_N}" class="over" height="120px" width="120px"></canvas>
                    <div class="label" onClick="clean(${i})">${B_S[i]}</div>
                    <div id='l${i}' class="small-label" onClick="verify(${i})"></div>
                </div>
        `)
    }
    $("info").innerHTML = `Session name: '<i>${localStorage.uuid}</i>', sets recorded: ${DATA.length/B_N}`
    $("all").innerHTML = str.join("");
    for(let i=0; i<B_N; i++){
        $(`c${i+B_N}`).style.display = "none";
    }
    $

    str = [];
    str.push(`<tr><th>Label</th><th colspan="${G_N**2}">Pixel Data</th></tr>`);
    if(DATA){
        for(let i=0; i<DATA.length; i++){
            str.push(`<tr><td>${DATA[i][0]}</td>`);
            for(let j=1; j<=G_N**2; j++){
                str.push(`<td>${DATA[i][j].toFixed(2)}</td>`);
            }
            str.push(`</tr>`);
        }    
    }

    $("data").innerHTML = str.join("");
}

function verify(n){
    if(!B_C[n]){
        clean(n+B_N)
        let arr = print(n);
        let context = $(`c${n+B_N}`).getContext('2d');
    
        for(let i=0; i<=G_N**2; i++){
            context.fillStyle = `rgba(0,0,0, ${arr[i+1]})`
            context.fillRect(i%G_N*G_D, Math.floor(i/G_N)*G_D, G_D, G_D);
        }
        $(`c${n+B_N}`).style.display = "block";
        $(`l${n}`).style.background = "#00AA00";
        $(`c${n}`).style.display = "none";
    }
    else{
        $(`c${n+B_N}`).style.display = "none";
        $(`l${n}`).style.background = "#303030";
        $(`c${n}`).style.display = "block";
    }
    B_C[n] = !B_C[n];
}

function writer(){
    if(!write){
        for(let i=0; i<B_N; i++){
            if(!B_C[i]){
                verify(i);
            }
        }
        $("control").innerHTML = `<button onClick="save(); writer()">Save</button><button onClick="writer()">Clear</button>`
    }
    else{
        for(let i=0; i<B_N; i++){clean(i)};
        $("control").innerHTML = `<div id="control"><button onClick="writer()">Verify</button></div>`
    }
    write = !write; 
}

function save(){
    let str = [];
    for(let i=0; i<B_N; i++){
        let d = print(i);
        DATA.push(d);

        str.push(`<tr><td>${d[0]}</td>`);
        for(let j=1; j<=G_N**2; j++){
            str.push(`<td>${d[j].toFixed(2)}</td>`);
        }
        str.push(`</tr>`);
    }

    $("data").innerHTML += str.join("");
    $("info").innerHTML = `Session name: ${localStorage.uuid}, sets recorded: ${DATA.length/B_N}`

    localStorage.data = JSON.stringify(DATA);
}

let showData = false;
$("data").style.display = "none";
function toggleData(){
    showData = !showData;
    $("data").style.display = showData ? "block":"none";
    $("showDataLabel").innerHTML = showData ? "Hide Data":"Show Data";
}

// https://stackoverflow.com/questions/14964035/how-to-export-javascript-array-info-to-csv-on-client-side
function download(){
    let csvContent = "data:text/csv;charset=utf-8,";

    DATA.forEach(function(rowArray) {
        let row = rowArray.join(",");
        csvContent += row + "\r\n";
    });

    var encodedUri = encodeURI(csvContent);
    var link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", `${localStorage.uuid}(${DATA.length/B_N}sets)-handwritten`);
    document.body.appendChild(link); 

    link.click(); 
}