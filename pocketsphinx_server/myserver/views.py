from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from pocketsphinx import Pocketsphinx, DefaultConfig, get_data_path, get_model_path, Jsgf, Config, Decoder
import os
import wave
import pyaudio


chunk = 1024
sample_format = pyaudio.paInt16
channels = 1
fs = 16000
p = pyaudio.PyAudio()

# Create your views here.
@csrf_exempt
def index(request):
    if request.method == "POST":
        # Store phoneme acoustic scores in array
        scores = []
        word = request.POST.get("word")
        print("Size of files:", len(request.FILES))
        print("Word used", word)

        # Write audio to wav file
        handle_file(request.FILES['audio'], word)
        # Retrieve Scores using PocketSphinx
        scores = retrieve_scores(word)

        data = {
            'scores': scores
        }

        return JsonResponse(data)
    else:
        return HttpResponse("Received some other type of request.")

def handle_file(f, word):
    # Initialize array to store frames
    frames = []
    filename = word + ".wav"

    # Store data in chunks
    for chunk in f.chunks():
        frames.append(chunk)

    # Save the recorded data as a WAV file
    wf = wave.open(filename, 'wb')
    wf.setnchannels(channels)
    wf.setsampwidth(p.get_sample_size(sample_format))
    wf.setframerate(fs)
    wf.writeframes(b''.join(frames))
    wf.close()

'''
Prints the phoneme and its corresponding acoustic score
'''
def print_segments(dec):
    for s in dec.seg():
        print('word: %s, acoustic score: %s' % (s.word, s.ascore))

'''
Retrieves the acoustic score for each phoneme and stores it in an array
'''
def retrieve_segments(dec):
    arr = []
    for s in dec.seg():
        arr.append(s.ascore)
    return arr

def retrieve_scores(word):
    filename = word + '.wav'
    grammarname = word + '-align.jsgf'
    model_path = get_model_path()

    # Initialize the config values
    config = DefaultConfig()
    config.set_boolean('-verbose', False)
    config.set_string('-hmm', os.path.join(model_path, 'en-us'))
    config.set_boolean('-lm', False)
    config.set_string('-dict', 'phonemes.dict.txt')
    config.set_boolean('-backtrace', True)
    config.set_boolean('-bestpath', False)
    config.set_boolean('-fsgusefiller', False)

    decoder = Decoder(config)

    # Set the search to JSGF Grammar
    jsgf = Jsgf(grammarname)
    rule = jsgf.get_rule('forcing.' + word)
    decoder.set_jsgf_file('grammar', grammarname)
    decoder.set_search('grammar')

    stream = open(filename, 'rb')
    utt_started = False
    scores = []
    decoder.start_utt()

    while True:
        buf = stream.read(1024)
        if buf:
            decoder.process_raw(buf, False, False)
            in_speech = decoder.get_in_speech()
            if (in_speech and not utt_started):
                utt_started = True
            if (not in_speech and utt_started):
                decoder.end_utt()
                hyp = decoder.hyp()
                if hyp is not None:
                    print('hyp: %s' % (hyp.best_score))
                print_segments(decoder)
                scores = retrieve_segments(decoder)
                decoder.start_utt()
                utt_started = False
        else:
            break

    decoder.end_utt()
    print('scores:', scores)

    return scores 
    