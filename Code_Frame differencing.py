from matplotlib import pyplot as plt
import cv2 as cv
videoPath = 'C:\\Users\\Moham\\PycharmProjects\\temp3\\video.mp4'
cap = cv.VideoCapture(videoPath)
while not cap.isOpened():
    print(f"The following path is not a valid pass for a video !\n{videoPath}")
    videoPath = input("If you want to use webcam please enter 'c' otherwise Please enter a valid pass to a video : ")
    if videoPath.lower() == 'c':
        videoPath = 0
        print("\nFor exit press 'Q'")
    cap = cv.VideoCapture(videoPath)

# Resizing the output video to an arbitrary scale
def frame_resize (frame, scalePercentage=100):
    width = int(frame.shape[1] * scalePercentage / 100)
    height = int(frame.shape[0] * scalePercentage / 100)
    dimension = (width, height)
    frame = cv.resize(frame, dimension, interpolation=cv.INTER_AREA )
    return frame

# Plot a frame
def plot_image(winName, frame):
    frame = cv.cvtColor(frame, cv.COLOR_RGB2BGR)
    plt.title(winName)
    plt.imshow(frame)
    plt.xticks([]), plt.yticks([])
    plt.show()

# Plot multiple frames
def plot_imgage_one_page(titles, images):
    for i in range(len(titles)):
        plt.subplot(2, 3, i+1)
        images[i] = cv.cvtColor(images[i], cv.COLOR_RGB2BGR)
        plt.title(titles[i])
        plt.xticks([]), plt.yticks([])
        plt.imshow(images[i])
    plt.show()


scale = 55
cap.set(cv.CAP_PROP_POS_FRAMES, 0)    # Set frame position
_, frame1 = cap.read()    # Reading the first frame
_, frame2 = cap.read()    # Reading the second frame
frame1 = frame_resize(frame1, scale)    # Scale the frame1 to arbitrary size
while True:
    framePos = cap.get(cv.CAP_PROP_POS_FRAMES)
    print(framePos)    # Printing frame position
    frame2 = frame_resize(frame2, scale)    # Scale the frame1 to arbitrary size
    frameGray1 = cv.cvtColor(frame1, cv.COLOR_BGR2GRAY)    # Converting to GrayScale
    frameGray2 = cv.cvtColor(frame2, cv.COLOR_BGR2GRAY)
    frameDiff = cv.absdiff(frameGray1, frameGray2)    # Calculate the absolute difference
    frameBlur = cv.GaussianBlur(frameDiff, (3, 3), 0)    # Apply Blurring filter
    _, frameThreshold = cv.threshold(frameBlur, 20, 255, cv.THRESH_BINARY)    # Filter pixels with intensity lower than th
    cv.imshow('Original Input', frame1)
    frameDilate = cv.dilate(frameThreshold, None, iterations=3)    # Dilate the mask image to fill the holes
    frameContours, _ = cv.findContours(frameDilate, cv.RETR_TREE, cv.CHAIN_APPROX_SIMPLE)    # Create contours
    # cv.drawContours(frame1, frameContours, -1, (30, 50, 230), 2)    # Draw contours on the frame
    for contour in frameContours:   # Draw bounding rectangles abound the detected contours
        x, y, width, height = cv.boundingRect(contour)
        if cv.contourArea(contour) < 600:    # Filter small contours
            continue
        else:
            cv.rectangle(frame1, (x, y), (x+width, y+height), (0, 165, 255), 2)
            cv.putText(frame1, 'Motion', (int(frame1.shape[1]*0.03), int(frame1.shape[0]*0.09)), cv.FONT_HERSHEY_SIMPLEX, 0.6, (70, 70, 250), 2)
    # images = [frame2, frameGray2, frameDiff, frameBlur, frameThreshold, frameDilate]
    # titles = ['Original', 'Convert to Gray', 'Difference', 'Blur', 'Threshold', 'Dilated']
    # plot_imgage_one_page(titles, images)
    cv.imshow('Frame Differencing Final output', frame1)
    frame1 = frame2    # assign frame2 to the frame1 var
    ret, frame2 = cap.read()    # Read the next frame to frame2
    if not ret:
        break
    if cv.waitKey(30) == ord('q'):    # Specify a time period for showing a frame and 'Q' key for Exit
         break
cv.destroyAllWindows()

