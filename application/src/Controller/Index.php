<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

final class Index extends AbstractController
{
    /**
     * @Route("/", name="index", methods={"GET"})
     */
    public function __invoke(): Response
    {
        return $this->render('base.html.twig', ['pages' => ['app']]);
    }
}
