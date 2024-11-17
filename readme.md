# **Sun and Shadow Detection Script**

This is a **basic and foundational mod** designed to demonstrate how to calculate the sun's position and check whether a player is in sunlight or shadow within a game environment. **Think of this script as a starting point** — a simple example of what's possible.

Feel free to **improve its performance, expand its functionality**, or adapt it to your creative ideas. The script is open-source and aims to inspire innovation in dynamic game mechanics.

---

## **Overview**

The script continuously calculates the sun's position relative to the player and checks for obstacles (such as buildings or objects) blocking the sun. This determines whether the player is in direct sunlight or shadow.

### **Why Use This?**  
This is not a complete mod, but rather a **demonstration of a powerful concept**. You can build upon it to implement:  
- **Dynamic gameplay mechanics**: Add effects when the player enters shadow or sunlight.  
- **Visual enhancements**: Create realistic lighting, shadows, or weather effects.  
- **Unique interactions**: Design gameplay features such as stealth mechanics, sunlight-sensitive creatures, or environmental reactions.

---

## **Features**

1. **Real-Time Sun Position Calculation**:  
   The script uses in-game time to calculate the sun's position, differentiating between daytime and nighttime.

2. **Shadow Detection**:  
   Now utilizes the function `HasEntityClearLosToCoord` to detect obstructions between the player and the sun, optimizing shadow detection and improving performance.

3. **Debugging Tools**:  
   - Visualize the sun's position and the raycast path.  
   - Display detailed information on-screen for debugging.

4. **Expandable Design**:  
   Serves as a base for more advanced features and optimizations.

---

## **How to Use**

1. Copy the script to your project folder.
2. Configure the `Config.debugmode` variable:  
   - `true`: Enables debugging tools to visualize and test the system.  
   - `false`: Disables debugging for normal gameplay.

3. The script will run automatically, continuously checking if the player is in sunlight or shadow.

### **Debug Mode**  
- A yellow line will be drawn from the player to the sun.  
- Information about the raycast, the sun's position, and hit status will be displayed on the screen and console.

---

## **Customization and Ideas for Expansion**

This script is intentionally simple to encourage modification and experimentation. Here are some ideas to expand its functionality:

- **Performance Optimizations**:  
   - Add a cooldown to the raycasting checks to reduce CPU load.  
   - Use distance checks to skip calculations when the player is indoors.

- **Gameplay Features**:  
   - **Stealth mechanics**: Enemies detect players only when they’re in sunlight.  
   - **Heat system**: Increase or decrease the player’s stats based on exposure to sunlight.

- **Visual Effects**:  
   - **Dynamic shadows**: Adjust light and shadows in real-time based on the sun’s position.  
   - Add a visual indicator when the player enters or exits sunlight.

- **Sunlight Interactions**:  
   - Objects or creatures that react to sunlight (e.g., solar-powered items or light-sensitive monsters).

---

## **Important Notes**

- **This is a demonstration script.** It is not intended for production use as-is. Performance optimizations and enhancements are necessary for larger environments or complex use cases.  
- The script is written for **free and open use by the community**. Feel free to modify it to suit your project needs.

---

## **License**

This script is released under the **MIT License**.  
You are free to use, modify, and distribute it, whether for personal or commercial purposes.

---

## **Contribution**

We welcome contributions! If you optimize the script or build something exciting based on it, consider sharing your work with the community to inspire others.

---
