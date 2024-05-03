import { useState } from "react";
import "./App.css";
import styled from "styled-components";
import axios from "axios";

function App() {
  const [text, setText] = useState("");

  const ClickButton = () => {
    axios
      .get("http://localhost:7071/api/test")
      .then((response) => setText(response.data.text))
      .catch((error) => console.log(error));
  };

  return (
    <>
      <StyledButton onClick={() => ClickButton()}>Click me</StyledButton>
      <h1>{text}</h1>
      <StyledImage
        src={"https://stirtrek.com/icons/opengraph.jpg"}
        alt="React Logo"
      />
    </>
  );
}

export default App;

const StyledImage = styled.img`
  max-height: 60vh;
  max-width: 90%;
`;

const StyledButton = styled.button`
  background-color: #fca311;
  color: #ffffff;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  font-size: 16px;
  cursor: pointer;
`;
