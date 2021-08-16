/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React from 'react';
import {Linking, Text, View} from 'react-native';

import {createAppContainer, createSwitchNavigator} from 'react-navigation';
import {createStackNavigator} from 'react-navigation-stack';
import LP from './LP';

const uriPrefix = 'notiftest://';

export const LibraryStack = createStackNavigator({
  default: {
    path: 'mylib',
    screen: () => <Text>{uriPrefix}lib/mylib</Text>,
  },
  WorkProfileScreen: {
    path: 'book/:id',
    screen: ({
      navigation: {
        state: {
          params: {id},
        },
      },
    }) => <Text>{uriPrefix}lib/book/{id}</Text>,
  },
});

const RootNav = {
  LibraryScreen: {
    screen: LibraryStack,
    path: 'lib',
  },
  AnimationScreen: {
    screen: () => <Text>no url handled</Text>,
  },
};

export const RootStack = createAppContainer(
  createSwitchNavigator(RootNav, {
    initialRouteName: 'AnimationScreen',
    headerMode: 'none',
  }),
);

class App extends React.Component<{initialURL: ?string}, {}> {
  constructor(props) {
    super(props);
    console.log('initial url props', props.initialURL);
    LP.start();
  }
  componentDidMount() {
    // Linking.openURL(uriPrefix+'lib/book/9782264064066')
    //   .then(console.log)
    //   .catch(console.warn);
  }

  onNavigationStateChange = () => {
    console.log('onNavigationStateChange');
  };

  render() {
    return (
      <View
        style={{
          flex: 1,
          flexDirection: 'row',
          justifyContent: 'space-between',
          alignItems: 'center',
        }}>
        <RootStack
          enableURLHandling={true}
          uriPrefix={uriPrefix}
          onNavigationStateChange={this.onNavigationStateChange}
        />
      </View>
    );
  }
}

export default App;
