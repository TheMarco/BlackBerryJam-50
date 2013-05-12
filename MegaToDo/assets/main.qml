// Default empty project template
import bb.cascades 1.0
import bb.system 1.0
import "json_parse.js" as JSONFunctions
// creates one page with a label
NavigationPane {

    Menu.definition: MenuDefinition {
        actions: [
            ActionItem {
                title: "About"
                imageSource: "images/ic_info.png"
                onTriggered: {
                    aboutSheet.open();
                }
            }
        ] // end of actions list
    } // end of MenuDefinition
    
    
    id: megaToDo
    Page {
        property string activeItem
        id: megaToDoMain
        titleBar: TitleBar {
            title: "MegaToDo"
        }
        property alias todolistcontroller: todolistcontroller
        actions: [
            ActionItem {
                title: "New Item"
                imageSource: "images/ic_add.png"
                ActionBar.placement: ActionBarPlacement.OnBar

                onTriggered: {
                    newItemData.text = '';
                    newItem.open();
                }
            },
            ActionItem {
                title: "Clear List"
                imageSource: "images/ic_delete.png"
                ActionBar.placement: ActionBarPlacement.OnBar

                onTriggered: {
                    cleardialog.show();
                }
            }
        ]
        attachedObjects: [
            WebView {
                id: todolistcontroller
                url: "local:///assets/webview/todocontroller.html"
                onMessageReceived: {
                    if (message.data == 'clearlist') {
                        todolist.removeAll();
                    }
                    if (message.data.match('allitems')) {
                        console.log('message: ' + message.data);
                        todolist.removeAll();
                        var fulllist = message.data.split('~')[1];
                        console.log('getting all items' + fulllist);
                        var reallist = JSONFunctions.parse(fulllist);
                        for (var i = 0;i<reallist.length;i++) {
                            var createdControl = todolistitem.createObject();
                            var createdDivider = listseparator.createObject();
                            createdControl.textString = reallist[i];
                            createdControl.itemId = i;
                            todolist.insert(0, createdDivider);
                            todolist.insert(0, createdControl);
                        }
                        if (reallist.length === 0) {
                            var createdControl = todolistitem.createObject();
                            var createdDivider = listseparator.createObject();
                            createdControl.textString = 'Nothing to do. Add something!';
                            createdControl.itemId = -1;
                            todolist.insert(0, createdDivider);
                            todolist.insert(0, createdControl);
                        }
                    }
                }
            },
            SystemDialog {
                id: cleardialog
                title: qsTr("MegaToDo")
                body: qsTr("Clear entire list?")
                confirmButton.label: qsTr("OK")
                confirmButton.enabled: true
                cancelButton.label: qsTr("Cancel")
                cancelButton.enabled: true
                onFinished: {
                    var x = result;
                    if (x == SystemUiResult.ConfirmButtonSelection) {
                        todolistcontroller.postMessage('clear');
                    } else {
                        // do nothing!
                    }
                }
            },
            ComponentDefinition {
                id: todolistitem
                Container {
                    property string textString
                    property string itemId
                    contextActions: [
                        ActionSet {
                            title: "Action Set"
                            subtitle: "This is an action set."

                            actions: [
                                ActionItem {
                                    title: "Delete"
                                    imageSource: "images/ic_delete.png"
                                    onTriggered: {
                                        if(itemId > -1) {
                                        	todolistcontroller.postMessage('delete~' + itemId);
                                        }
                                    }
                                }
                            ]
                        } // end of ActionSet
                    ]
                    topPadding: 25
                    rightPadding: topPadding
                    leftPadding: rightPadding
                    Label {
                        text: textString
                        multiline: true
                        minWidth: 720
                        preferredWidth: 1280
                    }
                }
            },
            ComponentDefinition {
                id: listseparator
                Container {
                    topMargin: 25
                    Divider {
                    }
                }
            },
            Sheet {
                id: aboutSheet
                Page {
                    titleBar: TitleBar {
                        title: "About MegaToDo"
                        dismissAction: ActionItem {
                            title: "Back"
                            onTriggered: {
                                aboutSheet.close();
                            }
                        }
                    }
                    Container {
                        Container {
                            topPadding: 25
                            rightPadding: topPadding
                            leftPadding: rightPadding
                            Label {
                                multiline: true
                                text: "Look Ma! No C++!"
                            }
                            Label {
                                multiline: true
                                text: "An application by Marco van Hylckama Vlieg"
                            }
                            Label {
                                multiline: true
                                text: "For BlackBerry Jam 2013"
                            }
                            Label {
                                multiline: true
                                text: "Copyright © 2013, All Rights Reserved."
                            }
                        }
                    }
                }
            },
            Sheet {
                id: newItem
                content: Page {
                    titleBar: TitleBar {
                        title: "New TODO item"
                        dismissAction: ActionItem {
                            title: "Cancel"
                            onTriggered: {
                                newItem.close();
                            }
                        }
                    }
                    Container {
                        topPadding: 25
                        leftPadding: topPadding
                        rightPadding: topPadding
                        layout: StackLayout {
                            orientation: TopToBottom
                        }
                        TextField {
                            id: newItemData
                        }
                    	Button {
                        	text: "Add"
                        	onClicked: {
                        	    if(newItemData.text !== '') {
                        	    	todolistcontroller.postMessage('set~' + newItemData.text);
                                	newItem.close();
                                	}
                        	    }
                        }
                    }
                }
            }
        ]
        Container {
            ScrollView {
                Container {
                    id: todolist
                    layout: StackLayout {
                        orientation: TopToBottom
                    }
                }
            
            }
        }
    }
}
