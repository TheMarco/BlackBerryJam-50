/*   Copyright 2013 Marco van Hylckama Vlieg
 * 
 * email:marcovhv@gmail.com, twitter:@TheMarco
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 */

import bb.cascades 1.0
import bb.system 1.0
import "json_parse.js" as JSONFunctions

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
        ] 
    } 
    
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
                title: "Clear Done"
                imageSource: "images/ic_deleteselected.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                
                onTriggered: {
                    todolistcontroller.postMessage('deletedone');
                    // delete selected
                }
            },
            ActionItem {
                title: "Clear All"
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
                        todolist.removeAll();
                        var fulllist = message.data.split('~')[1];
                        var reallist = JSONFunctions.parse(fulllist);
                        for (var i = reallist.items.length-1;i>=0;i--) {
                            
                            var createdControl = todolistitem.createObject();
                            var createdDivider = listseparator.createObject();
                            var itemisdone = false;
                            for (var j = 0; j < reallist.done.length; j ++) {
                                if (reallist.done[j] == reallist.items.indexOf(reallist.items[i])) {
                                    itemisdone = true;
                                    break;
                                }
                            }
                            
                            if(itemisdone) {
                                createdControl.textString = '<html><span style="color:#cccccc;font-style:italic;">' + reallist.items[i] + '</span></html>';
                            }
                            else {
                                createdControl.textString = reallist.items[i];
                            }

							createdControl.itemId = i;
							todolist.insert(0, createdDivider);
							todolist.insert(0, createdControl);
                        }
                        
                        if (reallist.items.length === 0) {
                            var createdControl = todolistitem.createObject();
                            var createdDivider = listseparator.createObject();
                            createdControl.textString = 'Nothing to do!';
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
                    id: theItem
                    contextActions: [
                        ActionSet {
                            title: "Action Set"
                            subtitle: "This is an action set."
                            
                            actions: [
                                ActionItem {
                                    title: "Toggle Done"
                                    imageSource: "images/ic_done.png"
                                    onTriggered: {
                                        if(itemId > -1) {
                                            if(todoText.text.match('<html>')) {
                                                todoText.text = todoText.text.replace('<html><span style="color:#cccccc;font-style:italic;">', '').replace('</span></html>', '');
                                            }
else {
                                                todoText.text = '<html><span style="color:#cccccc;font-style:italic;">' + todoText.text + '</span></html>';
}
                                        }
                                        todolistcontroller.postMessage('toggledone~' + itemId);
                                        theItem.background = Color.Transparent;
                                    }
                                },
                                ActionItem {
                                    title: "Delete"
                                    imageSource: "images/ic_delete.png"
                                    onTriggered: {
                                        if (itemId > -1) {
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
                    bottomPadding: topPadding
                    onTouch: {
                        if (event.isDown()) {                         
                            theItem.background = Color.create('#00a7de');
                        }
                        if (event.isUp()) {
                            theItem.background = Color.Transparent;
                        }
                    }
                    Label {
                        id: todoText
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
