# ====================================================================
# Name:         Marcus Giarrusso
# Class:        Creative Code
# Date:          Wednesday, May 9th 2018
# Description:   Part 1 Facial Recognition: Proof of concept -
#                   Loads and encodes images of myself and
#                   classmates. Runs built-in camera via openCV
#                   library & loops checking individual in front
#                   of camera frame by frame & sees if it
#                   recognized them - drawing a redBox around
#                   their face. After which, it will launch
#                   that individual users workspace (Part 2).
# ====================================================================
import face_recognition  # Credit: https://github.com/ageitgey/face_recognition
import cv2
import os
import subprocess


# *** TODO: Need to correct this!
# launching Processing application & Workspace sketch
def confirm_app_launch(confirm_number):
    if confirm_number == 1:
        subprocess.call(["open", "-a", "Processing"])
        os.system("processing-java --sketch=~/Processing/Projects/SketchToRun --run")


# Get a reference to webcam
video_capture = cv2.VideoCapture(0)

# load sample picture & learn how to recognize it
sample_image = face_recognition.load_image_file("jobs.jpg")
sample_image_encoding = face_recognition.face_encodings(sample_image)[0]

# load 2nd sample image & learn how to recognize it
sample_2_image = face_recognition.load_image_file("zucks.jpg")
sample_2_image_encoding = face_recognition.face_encodings(sample_2_image)[0]

# load sample picture & learn how to recognize it
marcusImg = face_recognition.load_image_file("Marcus.jpg")
marcusImg_Encoding = face_recognition.face_encodings(marcusImg)[0]

# Create arrays of known face encodings & their names
known_face_encodings = [
    sample_image_encoding,
    sample_2_image_encoding,
    marcusImg_Encoding
]

known_face_names = [
    "jobs",
    "zucks",
    "Marcus"
]

# Optional if time
unknown_face_names = []
blocked_face_names = []

# Initialize some variables
face_locations = []
face_encodings = []
face_names = []
process_this_frame = True

# seconds & counter variables
seconds = 5
counter = 0
has_been_called = False

while True:

    # Grab a single video frame
    ret, frame = video_capture.read()

    # Resize video frame to 1/4 size for faster face recognition processing
    small_frame = cv2.resize(frame, (0, 0), fx=0.25, fy=0.25)

    # Convert the image from BGR color (OpenCV setting) to RGB color (face_recognition setting)
    rgb_small_frame = small_frame[:, :, ::-1]

    # Only process every other frame of video to save time
    if process_this_frame:
        # Find all faces & encodings in current video frame
        face_locations = face_recognition.face_locations(rgb_small_frame)
        face_encodings = face_recognition.face_encodings(rgb_small_frame, face_locations)

        face_names = []
        for face_encoding in face_encodings:
            # See if face matches known face
            matches = face_recognition.compare_faces(known_face_encodings, face_encoding)
            name = "Unknown..."

            # If match made in known_face_encodings, just use first one
            if True in matches:
                first_match_index = matches.index(True)
                name = known_face_names[first_match_index]
                # print(name)

                # counter to delay time, if recognized execute commands
                if counter > 80:

                    if not has_been_called:

                        if name == "Marcus":
                            has_been_called = True
                            confirm_app_launch(1)  # TODO: Need to correct this
                            # exit()

                face_names.append(name)

    process_this_frame = not process_this_frame

    # Display results
    for (top, right, bottom, left), name in zip(face_locations, face_names):
        top *= 4
        right *= 4
        bottom *= 4
        left *= 4

        # Draw a box around the face
        cv2.rectangle(frame, (left, top), (right, bottom), (0, 0, 255), 2)

        # Draw a label with a name below the face
        cv2.rectangle(frame, (left, bottom - 35), (right, bottom), (0, 0, 255), cv2.FILLED)
        font = cv2.FONT_HERSHEY_DUPLEX
        cv2.putText(frame, name, (left + 6, bottom - 6), font, 1.0, (255, 255, 255), 1)

    # Display resulting image
    cv2.imshow('Video', frame)

    # Counter Increment
    counter += 1
    # print('Count %d' % counter)
    # print('Has_been_called %s' % has_been_called)

    # Hit 'q' on keyboard to quit
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release handle to the webcam
video_capture.release()
cv2.destroyAllWindows()


# TODO: Add database & GUI if there is enough time (Or after in spare time)
# import sqlite3
# import time
# from tkinter import *
# from PIL import Image, ImageTk
#
#
# # Loading Images Using Database (Instead of using lines 31 - 41)
# person_dbImage = face_recognition.load_image_file(file)
# person_dbImage_encoding = face_recognition.face_encodings(person_dbImage)[0]
#
#
# # Creating / Opening Database
# def create_or_open_db(db_file):
#     db_is_new = not os.path.exists(db_file)
#     conn = sqlite3.connect(db_file)
#     if db_is_new:
#         print('Creating schema')
#         sql = '''create table if not exists PICTURES(
#         ID INTEGER PRIMARY KEY AUTOINCREMENT,
#         PICTURE BLOB,
#         TYPE TEXT,
#         FILE_NAME TEXT);'''
#         conn.execute(sql)  # shortcut for conn.cursor().execute(sql)
#     else:
#         print('Schema exists\n')
#     return conn
#
#
# # Inserting Images in Database
# def insert_picture(conn, picture_file):
#     with open(picture_file, 'rb') as input_file:
#         ablob = input_file.read()
#         base = os.path.basename(picture_file)
#         afile, ext = os.path.splitext(base)
#         sql = '''INSERT INTO PICTURES
#         (PICTURE, TYPE, FILE_NAME)
#         VALUES(?, ?, ?);'''
#         conn.execute(sql, [sqlite3.Binary(ablob), ext, afile])
#         conn.commit()
#
#
# # Getting Images From Database
# def extract_picture(cursor, picture_id):
#     sql = "SELECT PICTURE, TYPE, FILE_NAME FROM PICTURES WHERE id = :id"
#     param = {'id': picture_id}
#     cursor.execute(sql, param)
#     ablob, ext, afile = cursor.fetchone()
#     filename = afile + ext
#     with open(filename, 'wb') as output_file:
#         output_file.write(ablob)
#     return filename
#
#
# # Saving New / Unknown User
# def save_persons_image(entered_name):
#     camera_port = 0
#     framerate = 30
#     camera = cv2.VideoCapture(camera_port)
#     capture = cv2.VideoCapture(camera_port)
#     ret, frame = capture.read()
#     while True:
#         cv2.imshow('img1', frame)  # display the captured image
#         if cv2.waitKey(1) & 0xFF == ord('y'):  # save on pressing 'y'
#             cv2.imwrite('./' + entered_name + '.jpg', frame)
#             # person = input("Enter Name of Person: ")
#             # print(person)
#             cv2.destroyAllWindows()
#             break
#     capture.release()
#
#
# # Prompting For A New / Unknown User
# def prompt_for_new_person():
#     def hello(event=None):
#         get_name = gui_name_input.get()
#         print(get_name)
#         return
#
#     masterGUI = Tk()
#     masterGUI.configure(background="gray27")
#     gui_name_input = StringVar()
#     masterGUI.geometry("450x450+500+300")
#     masterGUI.title("User Name")
#     label_1 = Label(masterGUI, text="Label", bg="gray27", fg="white").pack()
#     button_1 = Button(masterGUI, text="Button", bd=0, highlightbackground="gray27", command=hello).pack()
#     photo = ImageTk.PhotoImage(file="personIcon2.jpeg")
#     pic_label = Label(masterGUI, bg="gray27", image=photo)
#     pic_label.pack()
#     entry_1 = Entry(masterGUI, textvariable=gui_name_input)
#     entry_1.bind("<Return>", hello)
#     entry_1.pack()
#     mainloop()
#
#
# def countdown_prompt():
#     for i in range(0, 5):
#         print(5 - i)
#         time.sleep(1)
#     print("..PROMPT")
#     exit()
#     prompt_for_new_person()
#
#
# conn = create_or_open_db('### Specified Database ###')
# picture_file = "### IMG ###"
# insert_picture(conn, picture_file)
# conn.close()
#
# conn = create_or_open_db('### Specified Database ###')
# cur = conn.cursor()
# filename = extract_picture(cur, 1)
# file = sql = extract_picture(cur, 1)
# cur.close()
# conn.close()
