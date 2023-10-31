import { RouteProp } from "@react-navigation/core";
import * as React from "react";
import { MainStackParamList } from "../NavigationParamList";
import { FrameNavigationProp } from "react-nativescript-navigation";
import { StyleSheet } from "react-nativescript";

type ScreenOneProps = {
  route: RouteProp<MainStackParamList, "AddProduct">;
  navigation: FrameNavigationProp<MainStackParamList, "AddProduct">;
};


export function addProduct({ navigation }: ScreenOneProps) {
  const productName = React.useRef<any>("");
  const barCode = React.useRef<any>("");

  return (
    <flexboxLayout style={styles.container}>
      <textField hint="Product name" ref={productName} />
      <textField hint="Bar code" ref={barCode} />
      <flexboxLayout>
        <button style={styles.buttonFullWidth} onTap={() => {}}>KG</button>
        <button style={styles.buttonFullWidth} onTap={() => {}}>UNITS</button>
      </flexboxLayout>
      <button onTap={() => {submit(navigation, productName, barCode)}}>SUBMIT</button>
    </flexboxLayout>
  );
}

async function submit(navigation: any, productName, barCode) {
  const x = await fetch("http://10.0.2.2:3000/products", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      name: refToString(productName),
      barCode: refToString(barCode),
    }),
  })
    .catch(x => console.log("\n\n", x,  "\n\n"));
  console.log('\n\n', x, '\n\n');
  navigation.navigate("Two", { message: "Product added: " + refToString(productName) });
}

function refToString(ref) {
  return ref.current.text.toString();
}

const styles = StyleSheet.create({
  container: {
    height: "100%",
    flexDirection: "column",
  },
  buttonFullWidth: {
    width: "100%",
  }
});
