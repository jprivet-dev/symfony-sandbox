<?php

namespace App\Controller;

use App\Mapper\TagDtoMapper;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class TagController extends AbstractController
{
    #[Route('/tags', name: 'app_tags')]
    public function allTags(TagDtoMapper $tagDtoMapper): Response
    {
        return $this->render('tags.html.twig', [
            'tags' => $tagDtoMapper->findAllWithPostsCount(),
        ]);
    }
}
