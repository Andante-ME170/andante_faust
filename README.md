# Andante project

This repository contains the source code for the Andante project (ME170 design capstone). The project involved mechatronic, mechanical, and software design for an electronic device that generates therapeutic music from gait.


Project Summary

Project Goal: Create music from the movement of cerebral palsy patients to encourage gait
improvement.

Background: Cerebral palsy (CP) is a neurological condition that affects approximately 764,000
people in the United States. People with spastic CP commonly experience gait disorders of
stiff-knee gait and flex-knee gait.

Project Motivation: Current therapies for spastic CP are provided at most 2-3 times per week
for an hour. This is a relatively low-dose frequency and thus requires a long period of time to
actually generate improvement in gait behavior. Additionally, therapies are sometimes not
motivating for CP individuals, which can lead to less desire to engage in beneficial exercises.
Problem Statement: Develop a mechatronic device that generates music from gait movement,
specifically focusing on musical implementations that can benefit those with spastic CP.

High Priority Requirements:

  ● Generate music as users walk -- let them make music through movement

  ● Improve gait for people with spastic cerebral palsy

  ● Enjoyable and satisfying musical interaction

  ● Device can be used at home for personal daily use

  ● Device must output consistent sensor data over the duration of use

Ethical Considerations:
  ● User safety - doesn’t negatively impact gait

  ● Device cost related to access

  ● Engaging musical options for users from a variety of backgrounds and cultures

Solution: We designed a flexible hardware and software system which can be adapted to replace
or augment a therapist’s auditory cues as well as provide other feedback. The system includes a
footswitch, a knee angle-detection sleeve, and an app that outputs music, which all communicate wirelessly via Bluetooth.


This repository contains the source code that was uploaded to the microcontrollers for both a knee sleeve and footswitch as well as code for the iOS app.
The mobile app receives data from the nRF52 microcontrollers via Bluetooth, which it then
translates into an audio output that can be heard by the user through the speaker on their phone.
