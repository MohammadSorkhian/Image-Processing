import cv2 as cv
from matplotlib import pyplot as plt
videoPath = 'C:\\Users\\Moham\\PycharmProjects\\temp3\\video.mp4'
cap = cv.VideoCapture(videoPath)
while not cap.isOpened():
    print(f"The following path is not a valid pass for a video !\n{videoPath}")
    videoPath = input("If you want to use webcam please enter 'c' otherwise Please enter a valid pass to a video : ")
    if videoPath.lower() == 'c':
        videoPath = 0
        print("\nFor exit press 'Q'")
    cap = cv.VideoCapture(videoPath)


def frame_resize (frame, scale=100):
    width = int(frame.shape[1]*scale/100)
    height = int(frame.shape[0]*scale/100)
    dimension = (width, height)
    frame = cv.resize(frame, dimension, interpolation=cv.INTER_AREA )
    return frame

scale = 55
cap.set(cv.CAP_PROP_POS_FRAMES, 0)   # Set frame position #
back_Sub = cv.createBackgroundSubtractorMOG2()
kernel = cv.getStructuringElement(cv.MORPH_ELLIPSE, (3, 3))

while True:
    framePos = cap.get(cv.CAP_PROP_POS_FRAMES)
    print(framePos)  # Printing frame position
    ret, frame = cap.read()
    if frame is None:
        break
    frame = frame_resize(frame, scale)
    foreGround = back_Sub.apply(frame)
    cv.imshow('Original Input', frame)
    frameBlur = cv.GaussianBlur(foreGround, (5, 5), 0)
    _, frameThreshold = cv.threshold(frameBlur, 150, 255, cv.THRESH_BINARY)
    frameOpen = cv.morphologyEx(frameThreshold, cv.MORPH_OPEN, kernel)    # Using kernel for opening/closing
    frameContours, _ = cv.findContours(frameOpen, cv.RETR_TREE, cv.CHAIN_APPROX_SIMPLE)
    # cv.drawContours(frame, frameContours, -1, (30, 50, 230), 2)
    for contour in frameContours:
        x, y, width, height = cv.boundingRect(contour)
        if cv.contourArea(contour) < 200:
            continue
        else:
            cv.rectangle(frame, (x, y), (x + width, y + height), (0, 165, 255), 2)
            cv.putText(frame, 'Motion', (int(frame.shape[1] * 0.03), int(frame.shape[0] * 0.09)),
            cv.FONT_HERSHEY_SIMPLEX, 0.6, (70, 70, 250), 2)
    cv.imshow('MOG2 Final Onput', frame)
    keyboard = cv.waitKey(30)
    if keyboard == ord('q'):
        break
