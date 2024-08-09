# 3D Game Development in Unity - Real Work Assignment

## Background

In a typical school, students can move ahead with their learning, even if they don't fully understand or learn a topic. This is problematic for some highly "stacked" skills such as math because, for example, if one doesn't fully understand fractions and exponents well, they will struggle to do more advanced algebra.

To address this issue and help students understand the importance of a solid foundation, we want to represent concepts (aka standards) students should know as blocks in a [Jenga](https://jengathreejs.netlify.app/) game. In contrast to the traditional Jenga game, we do not expect the students to remove blocks themselves - we shall do this for them based on the data we have collected from learning apps about their knowledge. However, we want to represent three distinct types of blocks:

- **Glass**, which symbolizes a concept the student does not know and needs to learn;
- **Wood**, which symbolizes a concept that the student has learned but was not tested on;
- **Stone**, which symbolizes a concept that the student was tested on and mastery was confirmed;

This structure helps the students better understand the topics they need to focus on, as it shows where they have gaps. For this assessment, you will develop a game in Unity to visualize a student's gaps: "Test my Stack". This mode eliminates all Glass blocks and activates the laws of physics, causing the stack to topple over if it has too many gaps.

## Your Work

1. Follow [the instructions below](#getting-started) to set up your project.
   - Please **do not fork this repository**, instead just clone it on your local machine.
   - Make sure to leverage any third-party libraries needed to keep the code as small as possible.
   - We have provided all the visual assets and a few pre-installed libraries that you can directly use.
2. Read [the requirements](#requirements) and [the grading criteria below](#grading). Implement the feature, following the given requirements.
3. Record a max 1-minute demo video, briefly showing the features you have implemented, following the Acceptance Test below.
   - Please share your recording as a video file (any major format is acceptable: LV, MOV, MPEG, MPG, MP4, WEBM, WMV).
   - We recommend using the native OS screen recording feature ([Mac](https://support.apple.com/en-us/102618), [Windows](https://www.microsoft.com/en-us/windows/learning-center/how-to-record-screen-windows-11))
   - You do not need to narrate or explain the code structure. Please just focus on demonstrating the functionality.
4. Submit your work by following [the instructions below](#submitting-your-work).

## Getting Started

1. **Download the Unity version** - Start by downloading the same Unity version used by this project `2022.3.15f1`
2. **Clone the Repository** - Run `git clone -b rwa/unity-development-v2 https://github.com/trilogy-group/ws-eng-unity-assessment` locally.
3. **Open the Project** - Open Unity Hub, click 'Add', navigate to the cloned repository, and add the project.

## Requirements

Build a 3D Unity game based on the following requirements:

- Use [this API](https://ga1vqcu3o1.execute-api.us-east-1.amazonaws.com/Assessment/stack) to fetch data about the Stacks.
  - There are 3 stacks for 3 different grades (6th, 7th, and 8th grade).
  - Although this API returns static data for this assessment, assume that the data is not constant and can change.
- Put the 3 stacks on a table in a row.
  - Use data from the API response to determine the block type:
    - mastery = 0 → Glass
    - mastery = 1 → Wood
    - mastery = 2 → Stone
  - Order the blocks in the stack starting from the bottom up, by domain name ascending, then by cluster name ascending, then by standard ID ascending.
- Enable orbit controls so that the user can rotate the camera around the stack:
  - One of the 3 stacks should always be in focus by default.
  - Add a control to switch the view between the 3 stacks.
- Implement the "Test my Stack" game mode described above, where you remove Glass blocks in the selected stack and enable physics.

Below is an example of how such a game may look:

![image](https://github.com/user-attachments/assets/f69562d2-37b6-42eb-a0e4-b7f5fd354b9e)

## Acceptance Test

- Given that you have the game open,
- (Screenshot) Then you can see the three stacks,
- And you can select a specific stack,
- And you can rotate around that stack,
- When you start the "Test my stack" game mode,
- Then the glass blocks are removed from the currently selected stack,
- And gravity affects the rest of the blocks of the stack (which wabbles/falls/etc).

## Submitting your Work

At the end of this assessment, please submit your work by doing the following:

- Add the demo video to the `Demo` folder of this repository,
- Take one screenshot of your game (showing the stacks) and place it in the `Demo` folder of this repository,
- Run the `./submit.ps1` or `./submit.sh` script provided in this repository. The script will create a `zip` file.
- Briefly check the `zip` file's contents to ensure your code, video, and screenshot are there.
- Lastly, continue running the script to upload the zip to our servers.

## Grading

Your work will be graded along the following criteria:

- **Completeness**: The final code should be functional, produce the desired output without significant errors, defects, or limitations, and address all the requirements, with minimal inconsistencies between requirement specifications and outputs (e.g., related to tower structure).
- **Code Quality**: The code written should be clean, efficient, consistent with the provided code, and adhere to typical game architecture, SOLID coding practices, and Unity best practices.
- **Aesthetics/UX**: The game's aesthetic should be engaging, and age-appropriate, with intuitive navigation.
