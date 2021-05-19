# MAST Capstone

A flutter mobile application for speech therapy. This application helps teachers organize their speech therapy classes. Teachers will have all of their students' data available to keep track of their progress, and students will be able to continuosly practice their speech using the application.

## PocketSphinx Server

### Installation

Using [Django](https://www.djangoproject.com/), we've created a server which uses [pocketsphinx-python](https://github.com/bambocher/pocketsphinx-python) for speech recognition.

In order to use the server, we require the following dependencies: `python django wave pyaudio pocketsphinx`.

To install Python and/or Django, please see this [link](https://docs.djangoproject.com/en/3.2/intro/install/).
You can verify that Django is installed by running **python** in your terminal. Then, try to import Djanog:
```
>>> import django
>>> print(django.get_version())
3.2
```

To install PocketSphinx-Python, please navigate into the mast_capstone directory and run the following:

 ```
git clone --recursive https://github.com/cmusphinx/pocketsphinx-python/
cd pocketsphinx-python
python setup.py install
 ```

 You can find the same instructions on how to install pocketsphinx-python, as well as many useful examples of the pocketsphinx-python library on CMUSphinx's github, [pocketsphinx-python](https://github.com/cmusphinx/pocketsphinx-python)

### How to run PocketSphinx Server

Once you have installed all of the dependencies as well as this project, navigate to pocketsphinx_server and execute the following commands to start up the server:
```
cd /Users/samminkin/Documents/Spring2021/Capstone/mast_capstone/pocketsphinx_server
python manage.py runserver 0:8000
```

This should result in the following output:
```
Watching for file changes with StatReloader
Performing system checks...

System check identified no issues (0 silenced).

You have 18 unapplied migration(s). Your project may not work properly until you apply the migrations for app(s): admin, auth, contenttypes, sessions.
Run 'python manage.py migrate' to apply them.
April 14, 2021 - 02:02:33
Django version 3.2, using settings 'pocketsphinx_server.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.
```

Notice that the server is running at http://127.0.0.1:8000. 127.0.0.1 is your computer's IP address - it literally means local host (running locally) - and it is running on port 8000. Therefore, to communicate with the server we need to send an http request to http://127.0.0.1:8000 with the audio file and word that we want to analyze.

## MAST_app

### Installation

To install Flutter, please follow the instructions at https://flutter.dev/docs/get-started/install. Make sure to set up Android Studio and Visual Studio Code in order to run the application. Steps 1-4 in 'Get Started' are highly recommended.

### Configuration

Since the PocketSphinx Server is running locally on our computers we need to set the IP address of our computer. If you are using a Mac then you can get your computer's IP address by running `ipconfig getifaddr en0`.

Next, navigate to /MAST_app/lib/Student/Model/DataRecord.dart and find the function **Future<List<int>> postAudioToServer(String word) async**. You will notice the first line contains the url of the server:
```
// URL of server is set HERE!!
String url = Platform.isAndroid ? "http://10.0.2.2:8000" : "http://127.0.0.1:8000";
```

Set the url according to the following rules - If you're using __ then set the IP address to __:
```
**Andorid Emulator** - http://10.0.2.2:8000
**IOS Simulator** - http://127.0.0.1:8000
**Physical Device** - http://{The IP address of computer where the server is running on}:8000
```

### How to run the Application

If you have MAST_app open in Visual Studio Code, make sure to install the Dart and Flutter plugins. Then, connect your device or open your emulator and make sure that Flutter recognizes it by running `flutter devices`. Then, execute Run->Run Without Debugging and select the target device to run the application on. 