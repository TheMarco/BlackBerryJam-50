// Default empty project template
import bb.cascades 1.0

// creates one page with a label
Page {
    Container {
        layout: StackLayout {}
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        Container {
            layout: StackLayout {}
            horizontalAlignment: HorizontalAlignment.Center
            WebView {
                id: game
                url: "local:///assets/webview/index.html"
                maxWidth: 600
                maxHeight: 320
            }
        }
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            horizontalAlignment: HorizontalAlignment.Fill
            topPadding: 20
            leftPadding: 20
            rightPadding: 20
            Button {
                id: leftbtn
                text: "Left"
                onClicked: {
                    game.postMessage('left');
                }
            }
            Button {
                id: stopbtn
                text: "Stop"
                onClicked: {
                    game.postMessage('stop');
                }
            }
            Button {
                id: rightbtn
                text: "Right"
                onClicked: {
                    game.postMessage('right');
                }
            }
        }
    }
}