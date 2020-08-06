import '../css/app.css';

import React from 'react';
import ReactDom from 'react-dom';
import IdentityFormContainer from './Identity/IdentityForm/IdentityFormContainer';

const App = () => {
  return (
    <>
      <h1>Hi</h1>
      <IdentityFormContainer />
    </>
  );
};

ReactDom.render(<App />, document.getElementById('root'));
