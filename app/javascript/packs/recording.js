import * as Tone from 'tone';

const jsPermitionButton = document.getElementById('js-mic-permition-button');
const jsStartRecordingButton = document.getElementById('js-recording-start-button');
const jsStopRecordingButton = document.getElementById('js-recording-stop-button');
const jsReplayButton = document.getElementById('js-replay-button');
const jsStopReplayButton = document.getElementById('js-stop-replay-button');
const jsPlayer = document.getElementById('js-player');
const jsDownLoardLink = document.getElementById('js-downloard-link');
const jsRecordingState = document.getElementById('js-recording-state');
const jsResetButton = document.getElementById('js-reset-button');

let audioContext = null;
let stream = null;
let bufferSize = 1024;
let audioSampleRate = null;
let scriptProcessor = null;
let audioData = [];
let timeout = null;
let recordedBlobUrl = null;

function onAudioProcess(e) {
  let input = e.inputBuffer.getChannelData(0);
  let bufferData = new Float32Array(bufferSize);
  for (let i = 0; i < bufferSize; i++) {
    bufferData[i] = input[i];
  }
  audioData.push(bufferData);
} 

function exportWAV(audioData) {
  let encodeWAV = function(samples, sampleRate) {
    let buffer = new ArrayBuffer(44 + samples.length * 2);
    let view = new DataView(buffer);

    let writeString = function(view, offset, string) {
      for (let i = 0; i < string.length; i++) {
        view.setUint8(offset + i, string.charCodeAt(i));
      }
    };

    let floatTo16BitPCM = function(output, offset, input) {
      for (let i = 0; i < input.length; i++, offset += 2) {
        let s = Math.max(-1, Math.min(1, input[i]));
        output.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7FFF, true);
      }
    };

    writeString(view, 0, 'RIFF');
    view.setUint32(4, 32 + samples.length * 2, true);
    writeString(view, 8, 'WAVE');
    writeString(view, 12, 'fmt ');
    view.setUint32(16, 16, true);
    view.setUint16(20, 1, true);
    view.setUint16(22, 1, true);
    view.setUint32(24, sampleRate, true);
    view.setUint32(28, sampleRate * 2, true);
    view.setUint16(32, 2, true);
    view.setUint16(34, 16, true);
    writeString(view, 36, 'data');
    view.setUint32(40, samples.length * 2, true);
    floatTo16BitPCM(view, 44, samples);
    return view;
  };

  let mergeBuffers = function(audioData) {
    let sampleLength = 0;
    for (let i = 0; i < audioData.length; i++) {
      sampleLength += audioData[i].length;
    }
    let samples = new Float32Array(sampleLength);
    let sampleIdx = 0;
    for (let i = 0; i < audioData.length; i++) {
      for (let j = 0; j < audioData[i].length; j++) {
        samples[sampleIdx] = audioData[i][j];
        sampleIdx++;
      }
    }
    return samples;
  };

  let dataview = encodeWAV(mergeBuffers(audioData), audioSampleRate);
  let audioBlob = new Blob([dataview], {type: 'audio/wav'});
  recordedBlobUrl = window.URL.createObjectURL(audioBlob);
  console.log(dataview);

  let myURL = window.URL || window.webkitURL;
  let url = myURL.createObjectURL(audioBlob);
  jsDownLoardLink.href = url;
}

function saveAudio() {
  exportWAV(audioData);
  jsDownLoardLink.downloard = 'voice.wav';
  audioContext.close().then(function() {
  });
}

jsPermitionButton.onclick = function() {
  jsPlayer.src = '';
  if(!stream) {
    navigator.mediaDevices.getUserMedia({
      video: false,
      audio: {
        echoCancellation: true,
        echoCancellationType: 'system',
        noiseSuppression: false
      }
    })
      .then(function(audio) {
        jsPermitionButton.classList.add('d-none');
        jsStartRecordingButton.classList.remove('d-none');

        stream = audio;
        console.log('録音可能です');
        return stream;
      })
      .catch(function(error) {
        console.error('mediaDevide.getUserMedia() error:', error);
        return;
      });
  }

  jsPermitionButton.disabled = true;
  jsStartRecordingButton.disabled = false;
  jsStopRecordingButton.disabled = true;
  jsReplayButton.disabled = true;
  jsStopReplayButton.disabled = true;
};

jsStartRecordingButton.onclick = function() {
  jsPlayer.src = '';

  jsStartRecordingButton.disabled = true;
  jsStopRecordingButton.disabled = false;
  jsReplayButton.disabled = true;
  jsStopReplayButton.disabled = true;

  jsStartRecordingButton.classList.add('d-none');
  jsStopRecordingButton.classList.remove('d-none');
  jsRecordingState.classList.remove('d-none');

  const micAudio = new Tone.UserMedia();
  micAudio.open();

  micAudio.open().then(() => {
    audioData = [];
    audioContext = new AudioContext();
    audioSampleRate = audioContext.sampleRate;
    scriptProcessor = audioContext.createScriptProcessor(bufferSize, 2, 2);

    const distortionAmount = 5;
    const pitch = -16;
    const vibratoFrequency = 40;
    const vibratoDepth = 0.1;
    const threshold = -50;
    const ratio = 4;
    const tremoloFrequency = 500;
    const tremoloDepth = 1;
    const lowLevel = 40;
    const midLevel = -20;
    const highLevel = 55;

    const distortion = new Tone.Distortion(distortionAmount);
    const pitchshift = new Tone.PitchShift(pitch);
    const vibrato = new Tone.Vibrato(vibratoFrequency, vibratoDepth);
    const compressor = new Tone.Compressor(threshold, ratio);
    const tremolo = new Tone.Tremolo(tremoloFrequency, tremoloDepth);
    const eq = new Tone.EQ3(lowLevel, midLevel, highLevel);
    const convolver = new Tone.Convolver('../../../../1960-G12M25-SM57-Cone-0_5in.wav');
    const effectedStreamDestination = Tone.context.createMediaStreamDestination();
    micAudio.chain(pitchshift, tremolo, vibrato, distortion, eq, convolver, compressor, effectedStreamDestination);
    
    const effectedStream = effectedStreamDestination.stream;
    const effectedStreamSource = audioContext.createMediaStreamSource(effectedStream);
    effectedStreamSource.connect(scriptProcessor);
    
    scriptProcessor.onaudioprocess = onAudioProcess;
    scriptProcessor.connect(audioContext.destination);

    timeout = setTimeout(() => {
      jsStopRecordingButton.click();
    }, 30000);
  
    jsStopRecordingButton.addEventListener('click', () => {
      clearTimeout(timeout);
      console.log('録音停止しました');
    });
  }).catch(e => {
    console.log('音声を加工・録音するプロセスに問題があります');
    console.log(e);
  });
};

jsStopRecordingButton.onclick = function() {
  jsStopRecordingButton.classList.add('d-none');
  jsReplayButton.classList.remove('d-none');
  jsRecordingState.classList.add('d-none');
  jsResetButton.classList.remove('d-none');

  saveAudio();
  jsPlayer.src = recordedBlobUrl;

  jsStartRecordingButton.disabled = false;
  jsStopRecordingButton.disabled = true;
  jsReplayButton.disabled = false;
};

jsReplayButton.onclick = function() {
  jsPlayer.play();
};

jsPlayer.onplay = function() {
  jsReplayButton.classList.add('d-none');
  jsStopReplayButton.classList.remove('d-none');

  jsReplayButton.disabled = true;
  jsStopReplayButton.disabled = false;
};

jsPlayer.onpause = function() {
  jsReplayButton.classList.remove('d-none');
  jsStopReplayButton.classList.add('d-none');

  jsReplayButton.disabled = false;
  jsStopReplayButton.disabled = true;
};

jsStopReplayButton.onclick = function() {
  jsPlayer.pause();
};

jsResetButton.onclick = function() {
  jsPlayer.src = '';

  jsStartRecordingButton.classList.remove('d-none');
  jsResetButton.classList.add('d-none');
  jsReplayButton.classList.add('d-none');
  jsStopReplayButton.classList.add('d-none');

  jsStartRecordingButton.disabled = false;
  jsReplayButton.disabled = true;
};
