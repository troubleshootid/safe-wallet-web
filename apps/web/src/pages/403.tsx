import { AppRoutes } from '@/config/routes'
import type { NextPage } from 'next'
import Link from 'next/link'
import MUILink from '@mui/material/Link'

const Custom403: NextPage = () => {
  return (
    <main>
      <h1>403 - Access Restricted</h1>
      <p>
        We regret to inform you that access to this service is currently unavailable in your region. For further
        information, you may refer to our{' '}
        <Link href={AppRoutes.terms}>
          {/* @next-codemod-error This Link previously used the now removed `legacyBehavior` prop, and has a child that might not be an anchor. The codemod bailed out of lifting the child props to the Link. Check that the child component does not render an anchor, and potentially move the props manually to Link. */
          }
          <MUILink target="_blank" rel="noreferrer">
            terms
          </MUILink>
        </Link>
        . We apologize for any inconvenience this may cause. Thank you for your understanding.
      </p>
    </main>
  );
}

export default Custom403
