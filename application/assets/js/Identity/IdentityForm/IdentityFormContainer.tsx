import { Formik } from 'formik';
import * as Yup from 'yup';
import React, { FC } from 'react';
import { defaultIdentity } from '../Identity';
import { IdentityForm } from './IdentityForm';

const validation = Yup.object().shape({
  firstName: Yup.string().required('firstName is required'),
  lastName: Yup.string().required('lastName is required'),
});

const IdentityFormContainer: FC = () => {
  return (
    <Formik
      validationSchema={validation}
      initialValues={defaultIdentity}
      onSubmit={(values) => {
        alert(JSON.stringify(values));
      }}
    >
      {() => <IdentityForm />}
    </Formik>
  );
};

export default IdentityFormContainer;
