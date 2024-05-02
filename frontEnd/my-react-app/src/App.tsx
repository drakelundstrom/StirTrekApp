import { useState } from "react";
import "./App.css";
import styled from "styled-components";

function App() {
  const [count, setCount] = useState(0);

  return (
    <>
      <StyledButton onClick={() => setCount(count + 1)}>Click me</StyledButton>
      <h1></h1>
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
