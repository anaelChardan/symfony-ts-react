import React, { FC } from 'react';
import InputText from '../../Form/InputText';

export const IdentityForm: FC = () => {
  return (
    <>
      <InputText label={'First Name'} name={'firstName'} />
    </>
  );
};
