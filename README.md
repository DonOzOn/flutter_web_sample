# Tetris Game - Flutter Web App

This Flutter web project contains a complete Tetris game that was copied from the flutter_game_plugin_sample project.

## 🎮 Features

- **Full Tetris Gameplay**: All 7 piece types (I, L, J, Z, S, O, T pieces)
- **Line clearing mechanics** with scoring and level progression
- **Keyboard + Touch Controls** for desktop and mobile
- **Game States**: Pause/resume, reset functionality
- **Simple Localization**: English interface
- **Web Ready**: Builds to static web files for deployment

## 🕹️ Controls

### Keyboard Controls:
- **↑ (Up Arrow)**: Rotate piece
- **↓ (Down Arrow)**: Move piece down faster  
- **← (Left Arrow)**: Move piece left
- **→ (Right Arrow)**: Move piece right
- **Space**: Drop piece instantly
- **P**: Pause/Resume game
- **R**: Reset game

### Touch Controls:
- Use the on-screen circular buttons for the same functionality
- Large "DROP" button for instant piece drop
- System buttons for pause/resume/reset

## 🚀 Quick Start

### For Development:
```bash
cd /Users/apple/Documents/NCB/miniapp_project/miniapp_web
flutter clean
flutter pub get
flutter run -d web-server --web-port 8080
```

### For Production Build:
```bash
cd /Users/apple/Documents/NCB/miniapp_project/miniapp_web
flutter build web
```

The built files will be in `build/web/` directory, ready for deployment to any web server.

### For Release Build with Optimization:
```bash
flutter build web --release --web-renderer html
```

## 🌐 Deployment

After running `flutter build web`, you can deploy the contents of the `build/web/` folder to:

- **GitHub Pages**: Upload to your repository's gh-pages branch
- **Netlify**: Drag and drop the build folder
- **Firebase Hosting**: Use `firebase deploy`
- **Any Web Server**: Upload files to your server's public directory

### Example deployment commands:

#### Firebase Hosting:
```bash
npm install -g firebase-tools
firebase login
firebase init hosting
flutter build web
firebase deploy
```

#### Simple Python Server (for testing):
```bash
cd build/web
python -m http.server 8080
```

## 📁 Project Structure

```
lib/
├── gamer/                 # Core game logic
│   ├── gamer.dart        # Main game controller & state management
│   ├── block.dart        # Tetris piece definitions & rotations
│   └── keyboard.dart     # Keyboard input handling
├── panel/                # Game UI components
│   ├── page_portrait.dart # Main game layout
│   ├── controller.dart   # Touch controls UI
│   ├── screen.dart       # Game screen with shake effects
│   ├── player_panel.dart # Playing field rendering
│   └── status_panel.dart # Score, level, next piece display
├── material/             # Visual rendering system
│   ├── material.dart     # Programmatic sprite generation
│   ├── briks.dart        # Individual block rendering
│   └── images.dart       # Numbers, icons, animations
├── simple_l10n.dart     # Simplified localization
├── tetris_game_view.dart # Game wrapper & navigation
└── main.dart            # App entry point

web/
├── index.html           # Main HTML template
├── manifest.json        # PWA manifest
├── favicon.png         # Browser icon
└── icons/              # App icons for PWA
```

## 🎨 Game Mechanics

### Scoring System:
- **Points**: Lines cleared × level × 5
- **Level**: Increases every 50 lines cleared (max level 6)
- **Speed**: Gets faster with each level

### Block Types:
- **I-piece**: 4-block line (best for clearing 4 lines at once)
- **O-piece**: 2×2 square (stable piece)
- **T-piece**: T-shaped with 4 rotation states
- **L & J-pieces**: L-shaped pieces (mirror images)
- **S & Z-pieces**: Zigzag pieces (mirror images)

### Special Effects:
- **Line clearing animation**: Flashing effect when lines are cleared
- **Screen shake**: When pieces hit the bottom
- **Next piece preview**: See what's coming next
- **Real-time clock**: Shows current time during gameplay

## 🛠️ Technical Details

### Performance Features:
- **Efficient Rendering**: Canvas-based programmatic sprites
- **Optimized Collision Detection**: Fast matrix-based checking
- **Smooth Animations**: 60fps gameplay with proper timing
- **Web Optimized**: Works on desktop and mobile browsers

### Browser Compatibility:
- **Chrome/Edge**: Full support
- **Firefox**: Full support  
- **Safari**: Full support
- **Mobile browsers**: Touch controls enabled

## 🎯 Customization

Edit these files to customize the game:

- **Colors**: `material/briks.dart` - Change block colors
- **Game Speed**: `gamer/gamer.dart` - Adjust speed array
- **Block Shapes**: `gamer/block.dart` - Modify piece shapes
- **UI Layout**: `panel/` directory - Update game interface
- **Scoring**: `gamer/gamer.dart` - Change point calculation

## 🔧 Build Options

### Development Build:
```bash
flutter build web --debug
```

### Production Build:
```bash
flutter build web --release
```

### With specific renderer:
```bash
flutter build web --web-renderer html    # Better compatibility
flutter build web --web-renderer canvaskit  # Better performance
```

### Profile Build (for performance analysis):
```bash
flutter build web --profile
```

## 🐛 Troubleshooting

### Build Issues:
1. **Missing web files**: Ensure `web/index.html` exists
2. **Asset errors**: Check asset paths in `pubspec.yaml`
3. **Memory issues**: Use `--web-renderer html` for compatibility

### Runtime Issues:
1. **Performance**: Try different web renderers
2. **Controls**: Ensure keyboard focus is on the game
3. **Assets**: Missing sprites will show fallback rectangles (game still works)

### Clean Build:
```bash
flutter clean
flutter pub get
flutter build web
```

## 📱 Progressive Web App (PWA)

The app includes PWA features:
- **Installable**: Users can install it as a native app
- **Offline Ready**: Caches resources for offline play
- **Responsive**: Works on all screen sizes

## 🌟 Next Steps

Optional improvements you could make:

1. **Real Icons**: Replace placeholder icons with actual PNG files
2. **Sound System**: Add audio files and uncomment sound code
3. **High Scores**: Implement localStorage for score persistence
4. **Multiplayer**: Add websocket-based multiplayer
5. **Themes**: Create multiple visual themes
6. **Analytics**: Add web analytics tracking

## 📝 License

This project is based on the original flutter_game_plugin_sample and is provided for educational and development purposes.

---

**🎉 Ready to build and deploy your Tetris game to the web! 🎉**

### Quick Deploy Checklist:
- [x] Web files created (`web/index.html`, `manifest.json`)
- [x] Build configuration ready
- [x] Progressive Web App features included
- [x] Touch and keyboard controls working
- [x] Responsive design for mobile and desktop

**Run `flutter build web` and your game is ready for the world! 🚀**
