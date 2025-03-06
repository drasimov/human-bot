const G_N = 8;
const G_D = 120/G_N;

const B_N = 10;
const B_S = [0,1,2,3,4,5,6,7,8,9];
const B_C = Array(B_S.length)

// const canvas = document.getElementById('sketchpad');
// const context = canvas.getContext('2d');

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
}
function print(n){
    let context = $('c' + n).getContext('2d')
    let arr = [];
    let info = [];
    for(let i=0; i<G_N**2; i++){
        info = context.getImageData(i%G_N*G_D, Math.floor(i/G_N)*G_D, G_D, G_D).data;

        let sum = 0;
        for(let j=0; j<info.length/4; j++){
            sum += info[j*4+3];
        }
        arr.push((4*sum/(info.length*255)).toFixed(4));
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
                <canvas id='c${i}'></canvas>
                <div class="label" onClick="clean(${i})">${B_S[i]}</div>
                <div class="label" onClick="verify(${i})">Check</div>

                <canvas id='c${i+B_N}' class="over"></canvas>
            </div>
        `)
    }
    $("all").innerHTML = str.join("");
}

function verify(n){
    if(B_C[n]){
        let arr = print(n);
        let context = $(`c${n+B_N}`).getContext('2d');
    
        for(let i=0; i<G_N**2; i++){
            context.fillStyle = `rgba(0,0,0, ${arr[i]})`
            context.fillRect(i%G_N*G_D, Math.floor(i/G_N)*G_D, G_D, G_D);
        }
        
    }

}