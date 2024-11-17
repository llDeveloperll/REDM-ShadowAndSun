# **Sun and Shadow Detection Script**  

This is a **basic and foundational mod** designed to demonstrate how to calculate the sun's position and check whether a player is in sunlight or shadow within a game environment. **Think of this script as a starting point**—a sandbox example of what’s possible.  

Feel free to **enhance its performance, expand its functionality**, or adapt it for your own creative ideas. The script is open-source and aims to inspire innovation in dynamic game mechanics.

---

## **Overview**  

The script continuously calculates the position of the sun relative to the player and checks for obstacles (like buildings or objects) blocking the sun. This determines whether the player is in direct sunlight or shadow.  

### **Why Use This?**  
This is not a complete mod, but rather a **demonstration of a powerful concept**. You can build upon it to implement:  
- **Dynamic gameplay mechanics**: Add effects when the player enters shadow or sunlight.  
- **Visual enhancements**: Create realistic lighting, shadows, or weather effects.  
- **Unique interactions**: Design gameplay features like stealth mechanics, sunlight-sensitive creatures, or environmental reactions.  

---

## **Features**  

1. **Real-time Sun Position Calculation**:  
   The script uses in-game time to calculate the sun's position, differentiating between daytime and nighttime.

2. **Shadow Detection**:  
   Uses raycasting to detect obstructions between the player and the sun.

3. **Debugging Tools**:  
   - Visualize the sun's position and raycast path.  
   - Display detailed information on the screen for debugging.  

4. **Expandable Design**:  
   Serves as a base for more advanced features and optimizations.

---

## **How to Use**  

1. Copy the script into your project folder.  
2. Configure the `Config.debugmode` variable:  
   - `true`: Enables debugging tools to visualize and test the system.  
   - `false`: Disables debugging for normal gameplay.  

3. The script will automatically run, continuously checking if the player is in sunlight or shadow.  

### **Debug Mode**  
- A yellow line will be drawn from the player to the sun.  
- Information about the raycast, the sun's position, and hit status will be printed to the screen and console.  

---

## **Customization and Ideas for Expansion**  

This script is intentionally kept basic to encourage modification and experimentation. Here are some ideas for expanding its functionality:  

- **Performance Optimizations**:  
   - Add a cooldown to the raycasting checks to reduce CPU load.  
   - Use distance checks to skip calculations when the player is indoors.  

- **Gameplay Features**:  
   - Stealth mechanics: Enemies detect players only when they’re in sunlight.  
   - Heat system: Increase or decrease a player’s stats based on exposure to sunlight.  

- **Visual Effects**:  
   - Dynamic shadows: Adjust light and shadows in real time based on the sun's position.  
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
